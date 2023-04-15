package pt.unl.fct.di.apdc.firstwebapp.resources;

import com.google.cloud.datastore.*;
import com.google.cloud.datastore.StructuredQuery.CompositeFilter;
import com.google.cloud.datastore.StructuredQuery.PropertyFilter;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import pt.unl.fct.di.apdc.firstwebapp.util.AuthToken;
import pt.unl.fct.di.apdc.firstwebapp.util.FullUserData;
import pt.unl.fct.di.apdc.firstwebapp.util.SimpleUserData;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.logging.Logger;

@Path("/users")
@Produces(MediaType.APPLICATION_JSON + ";charset=utf-8")
public class ListUsersResource {
    private static final String USER = "User";

    /**
     * Logger Object
     */
    private static final Logger LOG = Logger.getLogger(LoginResource.class.getName());

    private final Gson g = new Gson();

    public ListUsersResource(){

    }

    private final Datastore datastore = DatastoreOptions.getDefaultInstance().getService();
    private final KeyFactory keyFactory = datastore.newKeyFactory();


    @GET
    @Path("/")
    public Response listUsers(@Context HttpServletRequest request,
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

        LOG.fine("Listing users for user: " + username);

        Key userKey = keyFactory.setKind(USER).newKey(username);

        Key tokenKey = keyFactory.addAncestor(PathElement.of(USER, username))
                .setKind("AuthToken").newKey("token");

        Transaction txn = datastore.newTransaction();

        try {

            Entity user = txn.get(userKey);
            Entity authTokenStored = txn.get(tokenKey);
            if (authTokenStored == null || !magicNumber.equals(authTokenStored.getString("magicNumber"))
                    || expirationTime < System.currentTimeMillis()) {
                txn.rollback();
                LOG.warning("AuthToken is not valid.");
                return Response.status(Response.Status.CONFLICT).build();
            }

            if (user == null) {
                txn.rollback();
                LOG.warning("Operation failed: User does not exist");
                return Response.status(Response.Status.NOT_FOUND).build();
            } else {

                Query<Entity> query;
                if (role == 0L) {
                    Query<ProjectionEntity> newQuery = Query.newProjectionEntityQueryBuilder()
                            .setKind(USER)
                            .setProjection("username", "email", "name")
                            .setFilter(
                                    CompositeFilter.and(PropertyFilter.eq("role", 0L),
                                            PropertyFilter.eq("is_active", true), PropertyFilter.eq("is_private", false))
                            )
                            .build();

                    QueryResults<ProjectionEntity> users = txn.run(newQuery);


                    List<SimpleUserData> userList = new ArrayList();
                    users.forEachRemaining(u -> {
                        SimpleUserData uu = new SimpleUserData(u.getKey().getName(), u.getString("email"), u.getString("name"));
                        userList.add(uu);
                    });

                    txn.commit();

                    return Response.ok(g.toJson(userList)).build();

                } else if (role == 3L) {
                    query = Query.newEntityQueryBuilder()
                            .setKind(USER).build();
                } else {
                    query = Query.newEntityQueryBuilder()
                            .setKind(USER)
                            .setFilter(PropertyFilter
                                    .lt("role", role)).build();
                }

                QueryResults<Entity> users = txn.run(query);
                List<FullUserData> userList = new ArrayList();
                users.forEachRemaining(u -> {
                    FullUserData uu = new FullUserData(u.getKey().getName(), u.getString("password"), u.getString("password"), u.getString("email"),
                            u.getString("name"), u.getBoolean("is_private"), u.getString("phone_number"), u.getString("mobile_phone_number"),
                            u.getString("occupation"), u.getString("workplace"), u.getString("address"), u.getString("nif"), u.getString("profile_picture"), u.getBoolean("is_active"), u.getLong("role"));
                    userList.add(uu);
                });

                txn.commit();

                return Response.ok(g.toJson(userList)).build();
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
