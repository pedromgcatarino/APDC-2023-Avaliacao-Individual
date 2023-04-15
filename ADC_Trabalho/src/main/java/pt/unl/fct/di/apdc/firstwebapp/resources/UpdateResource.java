package pt.unl.fct.di.apdc.firstwebapp.resources;

import com.google.cloud.datastore.*;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import org.apache.commons.codec.digest.DigestUtils;
import pt.unl.fct.di.apdc.firstwebapp.util.AuthToken;
import pt.unl.fct.di.apdc.firstwebapp.util.RolesData;
import pt.unl.fct.di.apdc.firstwebapp.util.UserData;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.logging.Logger;

@Path("/update")
public class UpdateResource {
    private static final String USER = "User";
    private static final Logger LOG = Logger.getLogger(ComputationResource.class.getName());

    private final Gson g = new Gson();

    public UpdateResource(){

    }

    private final Datastore datastore = DatastoreOptions.getDefaultInstance().getService();
    private final KeyFactory keyFactory = datastore.newKeyFactory();

    @Path("/")
    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    public Response update(UserData updatedData, @Context HttpServletRequest request,
                           @Context HttpHeaders headers){
        String authTokenHeader = headers.getHeaderString("Authorization");
        String authToken = authTokenHeader.substring("Bearer".length()).trim();

        String username;
        long role;
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
        Key updatedUserKey = keyFactory.setKind(USER).newKey(updatedData.username);

        Key tokenKey = keyFactory.addAncestor(PathElement.of(USER, username))
                .setKind("AuthToken").newKey("token");

        Transaction txn = datastore.newTransaction();

        try {
            Entity authTokenStored = txn.get(tokenKey);
            if (authTokenStored == null || !magicNumber.equals(authTokenStored.getString("magicNumber"))
                    || expirationTime < System.currentTimeMillis()) {
                txn.rollback();
                LOG.warning("Operation failed: AuthToken is not valid");
                return Response.status(Response.Status.CONFLICT).build();
            }

            Entity user = txn.get(userKey);
            Entity oldUser = txn.get(updatedUserKey);
            Entity newUser;

            if (user == null || oldUser == null){
                txn.rollback();
                LOG.warning("Operation failed: User does not exist");
                return Response.status(Response.Status.NOT_FOUND).build();
            }

            if (role == 0L && username.equals(updatedData.username)){
                newUser = Entity.newBuilder(updatedUserKey)
                        .set("password", oldUser.getString("password"))
                        .set("email", oldUser.getString("email"))
                        .set("name", oldUser.getString("name"))
                        .set("is_private", updatedData.isPrivate)
                        .set("phone_number", StringValue.newBuilder(updatedData.phone_number).setExcludeFromIndexes(true).build())
                        .set("mobile_phone_number", StringValue.newBuilder(updatedData.mobile_phone_number).setExcludeFromIndexes(true).build())
                        .set("occupation", StringValue.newBuilder(updatedData.occupation).setExcludeFromIndexes(true).build())
                        .set("workplace", StringValue.newBuilder(updatedData.workplace).setExcludeFromIndexes(true).build())
                        .set("address", StringValue.newBuilder(updatedData.address).setExcludeFromIndexes(true).build())
                        .set("nif", StringValue.newBuilder(updatedData.nif).setExcludeFromIndexes(true).build())
                        .set("profile_picture", StringValue.newBuilder(updatedData.profile_pic_path).setExcludeFromIndexes(true).build())
                        .set("is_active", oldUser.getBoolean("is_active"))
                        .set("role", oldUser.getLong("role"))
                        .build();
            } else if (role > oldUser.getLong("role")){
                newUser = Entity.newBuilder(updatedUserKey)
                        .set("password", oldUser.getString("password"))
                        .set("email", updatedData.email)
                        .set("name", updatedData.name)
                        .set("is_private", updatedData.isPrivate)
                        .set("phone_number", StringValue.newBuilder(updatedData.phone_number).setExcludeFromIndexes(true).build())
                        .set("mobile_phone_number", StringValue.newBuilder(updatedData.mobile_phone_number).setExcludeFromIndexes(true).build())
                        .set("occupation", StringValue.newBuilder(updatedData.occupation).setExcludeFromIndexes(true).build())
                        .set("workplace", StringValue.newBuilder(updatedData.workplace).setExcludeFromIndexes(true).build())
                        .set("address", StringValue.newBuilder(updatedData.address).setExcludeFromIndexes(true).build())
                        .set("nif", StringValue.newBuilder(updatedData.nif).setExcludeFromIndexes(true).build())
                        .set("profile_picture", StringValue.newBuilder(updatedData.profile_pic_path).setExcludeFromIndexes(true).build())
                        .set("is_active", oldUser.getBoolean("is_active"))
                        .set("role", oldUser.getLong("role"))
                        .build();
            } else {
                txn.rollback();
                LOG.warning("Operation failed: No permissions");
                return Response.status(Response.Status.FORBIDDEN).build();
            }

            txn.put(newUser);
            txn.commit();
            LOG.info("User " + updatedData.username + " updated successfully.");
            return Response.ok("User updated").build();
        } catch (Exception e){
            txn.rollback();
            LOG.severe(e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).build();
        } finally {
            if (txn.isActive()) txn.rollback();
        }
    }

    @Path("/role")
    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    public Response changeRole(RolesData data, @Context HttpServletRequest request,
                               @Context HttpHeaders headers){
        String authTokenHeader = headers.getHeaderString("Authorization");
        String authToken = authTokenHeader.substring("Bearer".length()).trim();

        String username;
        long role;
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
        Key updatedUserKey = keyFactory.setKind(USER).newKey(data.username);

        Key tokenKey = keyFactory.addAncestor(PathElement.of(USER, username))
                .setKind("AuthToken").newKey("token");

        Transaction txn = datastore.newTransaction();

        try {
            Entity authTokenStored = txn.get(tokenKey);
            if (authTokenStored == null || !magicNumber.equals(authTokenStored.getString("magicNumber"))
                    || expirationTime < System.currentTimeMillis()) {
                txn.rollback();
                LOG.warning("Operation failed: AuthToken is not valid");
                return Response.status(Response.Status.CONFLICT).build();
            }

            Entity user = txn.get(userKey);
            Entity updateUser = txn.get(updatedUserKey);

            if (user == null || updateUser == null) {
                txn.rollback();
                LOG.warning("Operation failed: User does not exist");
                return Response.status(Response.Status.NOT_FOUND).build();
            }

            long oldRole = updateUser.getLong("role");
            long newRole = data.newRole;
            Entity updatedUser;

            if ((role == 0L && username.equals(data.username)) || role == 1L && oldRole == 0L){
                // USER
                updatedUser = Entity.newBuilder(updatedUserKey)
                        .set("password", updateUser.getString("password"))
                        .set("email", updateUser.getString("email"))
                        .set("name", updateUser.getString("name"))
                        .set("is_private", updateUser.getBoolean("is_private"))
                        .set("phone_number", StringValue.newBuilder(updateUser.getString("phone_number")).setExcludeFromIndexes(true).build())
                        .set("mobile_phone_number", StringValue.newBuilder(updateUser.getString("mobile_phone_number")).setExcludeFromIndexes(true).build())
                        .set("occupation", StringValue.newBuilder(updateUser.getString("occupation")).setExcludeFromIndexes(true).build())
                        .set("workplace", StringValue.newBuilder(updateUser.getString("workplace")).setExcludeFromIndexes(true).build())
                        .set("address", StringValue.newBuilder(updateUser.getString("address")).setExcludeFromIndexes(true).build())
                        .set("nif", StringValue.newBuilder(updateUser.getString("nif")).setExcludeFromIndexes(true).build())
                        .set("profile_picture", StringValue.newBuilder(updateUser.getString("profile_picture")).setExcludeFromIndexes(true).build())
                        .set("is_active", data.newState)
                        .set("role", updateUser.getLong("role"))
                        .build();
            } else if (role == 2L){
                // GS
                if (oldRole == 0L && newRole == 1L){
                    updatedUser = Entity.newBuilder(updatedUserKey)
                            .set("password", updateUser.getString("password"))
                            .set("email", updateUser.getString("email"))
                            .set("name", updateUser.getString("name"))
                            .set("is_private", updateUser.getBoolean("is_private"))
                            .set("phone_number", StringValue.newBuilder(updateUser.getString("phone_number")).setExcludeFromIndexes(true).build())
                            .set("mobile_phone_number", StringValue.newBuilder(updateUser.getString("mobile_phone_number")).setExcludeFromIndexes(true).build())
                            .set("occupation", StringValue.newBuilder(updateUser.getString("occupation")).setExcludeFromIndexes(true).build())
                            .set("workplace", StringValue.newBuilder(updateUser.getString("workplace")).setExcludeFromIndexes(true).build())
                            .set("address", StringValue.newBuilder(updateUser.getString("address")).setExcludeFromIndexes(true).build())
                            .set("nif", StringValue.newBuilder(updateUser.getString("nif")).setExcludeFromIndexes(true).build())
                            .set("profile_picture", StringValue.newBuilder(updateUser.getString("profile_picture")).setExcludeFromIndexes(true).build())
                            .set("is_active", updateUser.getBoolean("is_active"))
                            .set("role", data.newRole)
                            .build();
                } else if (oldRole == 1L){
                    updatedUser = Entity.newBuilder(updatedUserKey)
                            .set("password", updateUser.getString("password"))
                            .set("email", updateUser.getString("email"))
                            .set("name", updateUser.getString("name"))
                            .set("is_private", updateUser.getBoolean("is_private"))
                            .set("phone_number", StringValue.newBuilder(updateUser.getString("phone_number")).setExcludeFromIndexes(true).build())
                            .set("mobile_phone_number", StringValue.newBuilder(updateUser.getString("mobile_phone_number")).setExcludeFromIndexes(true).build())
                            .set("occupation", StringValue.newBuilder(updateUser.getString("occupation")).setExcludeFromIndexes(true).build())
                            .set("workplace", StringValue.newBuilder(updateUser.getString("workplace")).setExcludeFromIndexes(true).build())
                            .set("address", StringValue.newBuilder(updateUser.getString("address")).setExcludeFromIndexes(true).build())
                            .set("nif", StringValue.newBuilder(updateUser.getString("nif")).setExcludeFromIndexes(true).build())
                            .set("profile_picture", StringValue.newBuilder(updateUser.getString("profile_picture")).setExcludeFromIndexes(true).build())
                            .set("is_active", data.newState)
                            .set("role", updateUser.getLong("role"))
                            .build();
                } else {
                    LOG.warning("Operation failed: No permissions");
                    return Response.status(Response.Status.FORBIDDEN).build();
                }
            } else if (role == 3L){
                updatedUser = Entity.newBuilder(updatedUserKey)
                        .set("password", updateUser.getString("password"))
                        .set("email", updateUser.getString("email"))
                        .set("name", updateUser.getString("name"))
                        .set("is_private", updateUser.getBoolean("is_private"))
                        .set("phone_number", StringValue.newBuilder(updateUser.getString("phone_number")).setExcludeFromIndexes(true).build())
                        .set("mobile_phone_number", StringValue.newBuilder(updateUser.getString("mobile_phone_number")).setExcludeFromIndexes(true).build())
                        .set("occupation", StringValue.newBuilder(updateUser.getString("occupation")).setExcludeFromIndexes(true).build())
                        .set("workplace", StringValue.newBuilder(updateUser.getString("workplace")).setExcludeFromIndexes(true).build())
                        .set("address", StringValue.newBuilder(updateUser.getString("address")).setExcludeFromIndexes(true).build())
                        .set("nif", StringValue.newBuilder(updateUser.getString("nif")).setExcludeFromIndexes(true).build())
                        .set("profile_picture", StringValue.newBuilder(updateUser.getString("profile_picture")).setExcludeFromIndexes(true).build())
                        .set("is_active", data.newState)
                        .set("role", data.newRole)
                        .build();
            } else {
                LOG.warning("Operation failed: No permissions");
                return Response.status(Response.Status.FORBIDDEN).build();
            }
            txn.put(updatedUser);
            txn.commit();
            return Response.ok().build();
        } catch (Exception e){
            txn.rollback();
            LOG.severe(e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).build();
        } finally {
            if (txn.isActive()) txn.rollback();
        }
    }
}
