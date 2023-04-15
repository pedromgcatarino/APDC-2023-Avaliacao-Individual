package pt.unl.fct.di.apdc.firstwebapp.util;
import org.apache.commons.codec.digest.DigestUtils;

import java.util.UUID;
public class AuthToken {
	
	public static final long EXPIRATION_TIME = 1000*60*60; //1h

	private String username;
	private long role;
	private long creationTime;
	private long expirationTime;
	private String magicNumber;
	
	public AuthToken() {
		
	}
	
	public AuthToken(String username, long role) {
		this.username = username;
		this.role = role;
		this.creationTime = System.currentTimeMillis();
		this.expirationTime = this.creationTime + AuthToken.EXPIRATION_TIME;
		this.magicNumber = UUID.randomUUID().toString();;
	}

	public String getUsername() {
		return username;
	}

	public long getRole() {
		return role;
	}

	public long getCreationTime() {
		return creationTime;
	}

	public long getExpirationTime() {
		return expirationTime;
	}

	public String getMagicNumber() {
		return magicNumber;
	}
}