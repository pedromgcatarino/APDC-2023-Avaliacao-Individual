package pt.unl.fct.di.apdc.firstwebapp.resources;

import com.google.cloud.datastore.*;
import com.google.gson.Gson;
import pt.unl.fct.di.apdc.firstwebapp.util.AuthToken;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.logging.Logger;

@Path("/logout")
public class LogoutResource {
    private static final String USER = "User";
    private static final Logger LOG = Logger.getLogger(ComputationResource.class.getName());

    public LogoutResource(){

    }

    private final Datastore datastore = DatastoreOptions.getDefaultInstance().getService();
    private final KeyFactory keyFactory = datastore.newKeyFactory();

    @Path("/")
    @DELETE
    public Response logout(@Context HttpServletRequest request,
                           @Context HttpHeaders headers){
        String authTokenHeader = headers.getHeaderString("Authorization");
        String authToken = authTokenHeader.substring("Bearer".length()).trim();

        String jsonString = new String(Base64.getDecoder().decode(authToken), StandardCharsets.UTF_8);
        Gson g = new Gson();

        AuthToken authTokenModel = g.fromJson(jsonString, AuthToken.class);
        String username = authTokenModel.getUsername();

        Key tokenKey = keyFactory.addAncestor(PathElement.of(USER, username))
                .setKind("AuthToken").newKey("token");

        Transaction txn = datastore.newTransaction();

        try{
            txn.delete(tokenKey);
            txn.commit();
            LOG.info("Logged out successfully.");
            return Response.ok("Logged out").build();
        } catch (Exception e){
            txn.rollback();
            LOG.severe(e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).build();
        } finally {
            if (txn.isActive()) txn.rollback();
        }
    }
}

