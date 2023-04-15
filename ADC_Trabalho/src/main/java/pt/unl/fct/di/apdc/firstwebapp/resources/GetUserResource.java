package pt.unl.fct.di.apdc.firstwebapp.resources;

import com.google.cloud.datastore.*;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import pt.unl.fct.di.apdc.firstwebapp.util.AuthToken;
import pt.unl.fct.di.apdc.firstwebapp.util.FullUserData;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.List;
import java.util.logging.Logger;

@Path("/user")
@Produces(MediaType.APPLICATION_JSON + ";charset=utf-8")
public class GetUserResource {
    private static final String USER = "User";

    /**
     * Logger Object
     */
    private static final Logger LOG = Logger.getLogger(LoginResource.class.getName());

    private final Gson g = new Gson();

    public GetUserResource(){

    }

    private final Datastore datastore = DatastoreOptions.getDefaultInstance().getService();
    private final KeyFactory keyFactory = datastore.newKeyFactory();


    @GET
    @Path("/{username}")
    public Response getUser(@PathParam("username") String username, @Context HttpServletRequest request,
                            @Context HttpHeaders headers){

        String authTokenHeader = headers.getHeaderString("Authorization");
        String authToken = authTokenHeader.substring("Bearer".length()).trim();

        String sessionUsername;
        long expirationTime;
        String magicNumber;

        if (authToken != null) {

            String jsonString = new String(Base64.getDecoder().decode(authToken), StandardCharsets.UTF_8);
            Gson g = new Gson();

            try{
                AuthToken authTokenModel = g.fromJson(jsonString, AuthToken.class);
                sessionUsername = authTokenModel.getUsername();
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

        LOG.fine("Finding user: " + username);

        Key userKey = keyFactory.setKind(USER).newKey(username);

        Key tokenKey = keyFactory.addAncestor(PathElement.of(USER, sessionUsername))
                .setKind("AuthToken").newKey("token");

        Transaction txn = datastore.newTransaction();

        try {

            Entity u = txn.get(userKey);
            Entity authTokenStored = txn.get(tokenKey);

            if (authTokenStored == null || !magicNumber.equals(authTokenStored.getString("magicNumber"))
                    || expirationTime < System.currentTimeMillis()) {
                txn.rollback();
                LOG.warning("AuthToken is not valid.");
                return Response.status(Response.Status.CONFLICT).build();
            }

            if (u == null) {
                txn.rollback();
                LOG.warning("Operation failed: User does not exist");
                return Response.status(Response.Status.NOT_FOUND).build();
            } else {

                FullUserData user = new FullUserData(username, u.getString("password"), u.getString("password"), u.getString("email"),
                        u.getString("name"), u.getBoolean("is_private"), u.getString("phone_number"), u.getString("mobile_phone_number"),
                        u.getString("occupation"), u.getString("workplace"), u.getString("address"), u.getString("nif"), u.getString("profile_picture"), u.getBoolean("is_active"), u.getLong("role"));

                txn.commit();
                return Response.ok(g.toJson(user)).build();
            }
        } catch (Exception e){
            txn.rollback();
            LOG.severe(e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).build();
        } finally {
            if (txn.isActive()) txn.rollback();
        }
    }
}
