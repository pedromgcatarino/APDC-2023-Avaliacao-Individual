package pt.unl.fct.di.apdc.firstwebapp.util;

public class FullUserData {
    public String username;
    public String password;
    public String confirmation;
    public String email;
    public String name;
    public boolean isPrivate;
    public String phone_number;
    public String mobile_phone_number;
    public String occupation;
    public String workplace;
    public String address;
    public String nif;
    public String profile_pic_path;
    public boolean isActive;
    public long role;

    public FullUserData(){

    }

    public FullUserData(String username, String password, String confirmation, String email, String name, boolean isPrivate, String phone_number, String mobile_phone_number, String occupation, String workplace, String address, String nif, String profile_picture, boolean isActive, long role) {
        this.username = username;
        this.password = password;
        this.confirmation = confirmation;
        this.email = email;
        this.name = name;
        this.isPrivate = isPrivate;
        this.phone_number = phone_number;
        this.mobile_phone_number = mobile_phone_number;
        this.occupation = occupation;
        this.workplace = workplace;
        this.address = address;
        this.nif = nif;
        this.profile_pic_path = profile_picture;
        this.isActive = isActive;
        this.role = role;
    }
}
