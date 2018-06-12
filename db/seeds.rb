ContactSource.create(:name => "email")
ContactSource.create(:name => "phone")
ContactSource.create(:name => "facebook")
ContactSource.create(:name => "linkedin")
ContactSource.create(:name => "twitter")
ContactSource.create(:name => "github")

User.create(:first_name => "Super", :last_name => "Man", :is_admin => true)
Login.create(:identification => "superman", :password_digest => "$2a$10$NpthFWmgTCXv7NS/RizSi.c8mMmDUO19Ze3ymoo3/QQrwci/8REt6", :user_id => User.find_by(:first_name => "Super", :last_name => "Man")[:id])