package pt.unl.fct.di.apdc.firstwebapp.resources;

import com.google.cloud.datastore.*;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import org.apache.commons.codec.digest.DigestUtils;
import pt.unl.fct.di.apdc.firstwebapp.util.AuthToken;
import pt.unl.fct.di.apdc.firstwebapp.util.PasswordData;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.logging.Logger;

@Path("/password")
public class ChangePasswordResource {
    private static final String USER = "User";
    private static final Logger LOG = Logger.getLogger(ComputationResource.class.getName());

    public ChangePasswordResource(){

    }

    private final Datastore datastore = DatastoreOptions.getDefaultInstance().getService();
    private final KeyFactory keyFactory = datastore.newKeyFactory();

    @Path("/")
    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    public Response changePassword(PasswordData data, @Context HttpServletRequest request,
                                   @Context HttpHeaders headers){
        String authTokenHeader = headers.getHeaderString("Authorization");
        String authToken = authTokenHeader.substring("Bearer".length()).trim();

        String username;
        long role;
        //long creationTime;
        long expirationTime;
        String magicNumber;

        if (authToken != null) {

            String jsonString = new String(Base64.getDecoder().decode(authToken), StandardCharsets.UTF_8);
            Gson g = new Gson();

            try{
                AuthToken authTokenModel = g.fromJson(jsonString, AuthToken.class);
                username = authTokenModel.getUsername();
                role = authTokenModel.getRole();
                expirationTime = authTokenModel.getExpirationTime();
                magicNumber = authTokenModel.getMagicNumber();
            } catch (JsonSyntaxException e){
                LOG.warning("Operation failed: AuthToken is not valid");
                return Response.status(Response.Status.CONFLICT).build();
            }

        } else {
            LOG.warning("Operation failed: AuthToken is not valid");
            return Response.status(Response.Status.CONFLICT).build();
        }

        Key userKey = keyFactory.setKind(USER).newKey(username);
        Key tokenKey = keyFactory.addAncestor(PathElement.of(USER, username))
            .setKind("AuthToken").newKey("token");

        Transaction txn = datastore.newTransaction();

        try {
            Entity authTokenStored = txn.get(tokenKey);

            if (authTokenStored == null || !magicNumber.equals(authTokenStored.getString("magicNumber"))
                    || expirationTime < System.currentTimeMillis()){
                txn.rollback();
                LOG.warning("Operation failed: AuthToken is not valid");
                return Response.status(Response.Status.CONFLICT).build();
            }

            if (!data.isValid()){
                txn.rollback();
                LOG.warning("Operation failed: Input data is not valid");
                return Response.status(Response.Status.BAD_REQUEST).build();
            }

            Entity user = txn.get(userKey);

            if (user == null) {
                txn.rollback();
                LOG.warning("Operation failed: User does not exist");
                return Response.status(Response.Status.NOT_FOUND).build();
            }

            String hashedPwd = user.getString("password");
            if (hashedPwd.equals(DigestUtils.sha512Hex(data.oldPassword))) {

                Entity updatedUser = Entity.newBuilder(userKey)
                        .set("password", DigestUtils.sha512Hex(data.newPassword))
                        .set("email", user.getString("email"))
                        .set("name", user.getString("name"))
                        .set("is_private", user.getBoolean("is_private"))
                        .set("phone_number", StringValue.newBuilder(user.getString("phone_number")).setExcludeFromIndexes(true).build())
                        .set("mobile_phone_number", StringValue.newBuilder(user.getString("mobile_phone_number")).setExcludeFromIndexes(true).build())
                        .set("occupation", StringValue.newBuilder(user.getString("occupation")).setExcludeFromIndexes(true).build())
                        .set("workplace", StringValue.newBuilder(user.getString("workplace")).setExcludeFromIndexes(true).build())
                        .set("address", StringValue.newBuilder(user.getString("address")).setExcludeFromIndexes(true).build())
                        .set("nif", StringValue.newBuilder(user.getString("nif")).setExcludeFromIndexes(true).build())
                        .set("profile_picture", StringValue.newBuilder(user.getString("profile_picture")).setExcludeFromIndexes(true).build())
                        .set("is_active", user.getBoolean("is_active"))
                        .set("role", user.getLong("role"))
                        .build();

                txn.put(updatedUser);
                txn.commit();
                LOG.info("Updated password successfully.");
                return Response.ok("Password changed").build();
            } else {
                txn.rollback();
                LOG.warning("Operation failed: Password is incorrect");
                return Response.status(Response.Status.FORBIDDEN).build();
            }
        } catch (Exception e){
            LOG.severe(e.getMessage());
            txn.rollback();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).build();
        } finally {
            if (txn.isActive()) txn.rollback();
        }
    }
}
