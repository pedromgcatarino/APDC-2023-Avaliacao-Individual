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
import pt.unl.fct.di.apdc.firstwebapp.util.UserData;


@Path("/register")
@Produces(MediaType.APPLICATION_JSON + ";charset=utf-8")
public class RegisterResource {
	private static final String USER = "User";
	private static final Logger LOG = Logger.getLogger(ComputationResource.class.getName());

	private final Gson g = new Gson();

	public RegisterResource() {
		
	}
	
	private final Datastore datastore = DatastoreOptions.getDefaultInstance().getService();
	private final KeyFactory keyFactory = datastore.newKeyFactory();
	
	@POST
	@Path("/")
	@Consumes(MediaType.APPLICATION_JSON)
	public Response register(UserData data) {
		LOG.fine("Register attempt");

		if (data.notValid()) {
			LOG.warning("Operation failed: Input data is not valid");
			return Response.status(Status.BAD_REQUEST).build();
		}

		Key userKey = keyFactory.setKind(USER).newKey(data.username);

		Transaction txn = datastore.newTransaction();

		try{
			Entity user = txn.get(userKey);
			if (user != null){
				txn.rollback();
				LOG.warning("Operation failed: User already exists");
				return Response.status(Status.CONFLICT).build();
			} else {
				user = Entity.newBuilder(userKey)
						.set("password", DigestUtils.sha512Hex(data.password))
						.set("email", data.email)
						.set("name", data.name)
						.set("is_private", data.isPrivate)
						.set("phone_number", StringValue.newBuilder(data.phone_number).setExcludeFromIndexes(true).build())
						.set("mobile_phone_number", StringValue.newBuilder(data.mobile_phone_number).setExcludeFromIndexes(true).build())
						.set("occupation", StringValue.newBuilder(data.occupation).setExcludeFromIndexes(true).build())
						.set("workplace", StringValue.newBuilder(data.workplace).setExcludeFromIndexes(true).build())
						.set("address", StringValue.newBuilder(data.address).setExcludeFromIndexes(true).build())
						.set("nif", StringValue.newBuilder(data.nif).setExcludeFromIndexes(true).build())
						.set("profile_picture", StringValue.newBuilder(data.profile_pic_path).setExcludeFromIndexes(true).build())
						.set("is_active", data.isActive)
						.set("role", data.role)
						.build();

				txn.add(user);

				AuthToken token = new AuthToken(data.username, data.role);
				Key tokenKey = keyFactory.addAncestor(PathElement.of(USER, data.username))
						.setKind("AuthToken").newKey("token");

				Entity authToken = Entity.newBuilder(tokenKey)
						.set("username", token.getUsername())
						.set("creationTime", token.getCreationTime())
						.set("expirationTime", token.getExpirationTime())
						.set("magicNumber", token.getMagicNumber()).build();

				txn.put(authToken);
				txn.commit();

				LOG.info("Utilizador registado: " + data.username);
				return Response.ok(g.toJson(token)).build();
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
