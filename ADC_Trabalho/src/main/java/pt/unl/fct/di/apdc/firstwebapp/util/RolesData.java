package pt.unl.fct.di.apdc.firstwebapp.util;

public class RolesData {
    public String username;
    public long newRole;
    public boolean newState;

    public RolesData(){

    }

    public RolesData(String username, long newRole, boolean newState){
        this.username = username;
        this.newRole = newRole;
        this.newState = newState;
    }
}
