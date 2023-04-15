package pt.unl.fct.di.apdc.firstwebapp.resources;

import java.util.logging.Logger;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import com.google.cloud.datastore.*;
import com.google.gson.Gson;

import org.apache.commons.codec.digest.DigestUtils;
import pt.unl.fct.di.apdc.firstwebapp.util.AuthToken;
import pt.unl.fct.di.apdc.firstwebapp.util.LoginData;

@Path("/login")
@Produces(MediaType.APPLICATION_JSON + ";charset=utf-8")
public class LoginResource {
	private static final String USER = "User";
	private static final String PWD = "password";
	
	/**
	 * Logger Object
	 */
	private static final Logger LOG = Logger.getLogger(LoginResource.class.getName());
	
	private final Gson g = new Gson();

	public LoginResource() {

	}

	private final Datastore datastore = DatastoreOptions.getDefaultInstance().getService();
	private final KeyFactory keyFactory = datastore.newKeyFactory();

	@POST
	@Path("/")
	@Consumes(MediaType.APPLICATION_JSON)
	public Response login(LoginData data) {
		String username = data.username;
		LOG.fine("Login attempt by user: " + username);

		if (data.notValid()) {
			LOG.warning("Operation failed: Invalid input data");
			return Response.status(Status.BAD_REQUEST).build();
		}

		Key userkey = keyFactory.setKind(USER).newKey(username);

		Key tokenKey = keyFactory.addAncestor(PathElement.of(USER, username))
				.setKind("AuthToken").newKey("token");

		Transaction txn = datastore.newTransaction();

		try {
			Entity user = txn.get(userkey);
			if (user == null) {
				txn.rollback();
				LOG.warning("Operation failed: User does not exist");
				return Response.status(Status.NOT_FOUND).build();
			}

			String hashedPwd = user.getString(PWD);
				if (hashedPwd.equals(DigestUtils.sha512Hex(data.password))) {
					AuthToken token = new AuthToken(username, user.getLong("role"));

					Entity authToken = Entity.newBuilder(tokenKey)
							.set("username", token.getUsername())
							.set("creationTime", token.getCreationTime())
							.set("expirationTime", token.getExpirationTime())
							.set("magicNumber", token.getMagicNumber()).build();

					txn.put(authToken);
					txn.commit();
					LOG.info("User " + username + " logged in successfully.");
					return Response.ok(g.toJson(token)).build();
				} else {
					txn.rollback();
					LOG.warning("Operation failed: Password is incorrect");
					return Response.status(Status.FORBIDDEN).build();
				}
		} catch (Exception e){
			txn.rollback();
			LOG.severe(e.getMessage());
			return Response.status(Status.INTERNAL_SERVER_ERROR).build();
		} finally {
			if (txn.isActive()) txn.rollback();
		}
	}
}
