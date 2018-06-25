ContactSource.find_or_create_by(:name => "email")
ContactSource.find_or_create_by(:name => "phone")
ContactSource.find_or_create_by(:name => "facebook")
ContactSource.find_or_create_by(:name => "linkedin")
ContactSource.find_or_create_by(:name => "twitter")
ContactSource.find_or_create_by(:name => "github")

User.find_or_create_by(:first_name => "Super", :last_name => "Man", :is_admin => true)
Login.find_or_create_by(:identification => "superman", :password_digest => "$2a$10$NpthFWmgTCXv7NS/RizSi.c8mMmDUO19Ze3ymoo3/QQrwci/8REt6", :user_id => User.find_by(:first_name => "Super", :last_name => "Man")[:id])