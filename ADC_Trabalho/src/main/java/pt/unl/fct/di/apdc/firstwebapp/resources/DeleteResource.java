package pt.unl.fct.di.apdc.firstwebapp.resources;

import com.google.cloud.datastore.*;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import pt.unl.fct.di.apdc.firstwebapp.util.AuthToken;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.Response;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.logging.Logger;

@Path("/delete")
public class DeleteResource {
    private static final String USER = "User";
    private static final Logger LOG = Logger.getLogger(ComputationResource.class.getName());

    public DeleteResource() {

    }

    private final Datastore datastore = DatastoreOptions.getDefaultInstance().getService();
    private final KeyFactory keyFactory = datastore.newKeyFactory();

    @DELETE
    @Path("/{username}")
    public Response delete(@PathParam("username") String username, @Context HttpServletRequest request,
            @Context HttpHeaders headers) {

        String authTokenHeader = headers.getHeaderString("Authorization");
        String authToken = authTokenHeader.substring("Bearer".length()).trim();

        String removerUsername;
        long role;
        long expirationTime;
        String magicNumber;

        if (authToken != null) {

            String jsonString = new String(Base64.getDecoder().decode(authToken), StandardCharsets.UTF_8);
            Gson g = new Gson();

            try{
                AuthToken authTokenModel = g.fromJson(jsonString, AuthToken.class);
                removerUsername = authTokenModel.getUsername();
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

        LOG.fine("Attempt to delete user: " + username + " executed by user: " + removerUsername);


        Key tokenKey = keyFactory.addAncestor(PathElement.of(USER, removerUsername)).setKind("AuthToken").newKey("token");


        Transaction txn = datastore.newTransaction();
        try {
            Entity authTokenStored = txn.get(tokenKey);
            if (authTokenStored == null || !magicNumber.equals(authTokenStored.getString("magicNumber"))
                    || expirationTime < System.currentTimeMillis()){
                txn.rollback();

                LOG.warning("Operation failed: AuthToken is not valid");
                return Response.status(Response.Status.CONFLICT).build();
            }

            Key toDeleteKey = datastore.newKeyFactory().setKind(USER).newKey(username);
            Key toDeleteTokenKey = datastore.newKeyFactory().addAncestor(PathElement.of(USER, username)).setKind("AuthToken").newKey("token");
            Entity toDelete = txn.get(toDeleteKey);

            if (toDelete == null) {
                txn.rollback();
                LOG.warning("Operation failed: User does not exist");
                return Response.status(Response.Status.NOT_FOUND).build();
            }

            Long toDeleteRole = toDelete.getLong("role");
            if (role > toDeleteRole || role == 3L || (role == 0L && removerUsername.equals(username))) {

                txn.delete(toDeleteKey);

                txn.delete(toDeleteTokenKey);
                txn.commit();
                LOG.info("Removed user: " + username);
                return Response.ok("User removed").build();
            } else {
                txn.rollback();
                LOG.warning("Operation failed: No permissions");
                return Response.status(Response.Status.FORBIDDEN).build();
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
