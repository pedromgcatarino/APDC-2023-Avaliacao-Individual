package pt.unl.fct.di.apdc.firstwebapp.util;

public class PasswordData {
    public String oldPassword;
    public String newPassword;
    public String confirmation;

    public PasswordData(){

    }

    public PasswordData(String oldPassword, String newPassword, String confirmation){
        this.oldPassword = oldPassword;
        this.newPassword = newPassword;
        this.confirmation = confirmation;
    }

    public boolean isValid(){
        return (newPassword.equals(confirmation) && newPassword.length() >= 8);
    }
}
