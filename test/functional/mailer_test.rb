require 'test_helper'

class MailerTest < ActionMailer::TestCase

  setup { ActionMailer::Base.deliveries.clear }

  context "upon successfull registration application" do
    setup do
      @school = create(:school, name: "Example University")
      @registration = create(:registration,
        first_name: "Joe",
        last_name: "Smith",
        email: "joe.smith@example.com",
        city: "Anytown",
        state: "NY",
        school_id: @school.id,
        year: "1",
        interest: "Development",
        experience: "first",
        shirt_size: "L",
        dietary_medical_notes: "Peanut allergy"
      )
    end

    should "deliver email to registration" do
      email = Mailer.application_confirmation_email(@registration).deliver

      assert_equal [@registration.email],               email.to
      assert_equal "[BrickHack] Application Received",  email.subject

      assert_match "Joe Smith",                         email.encoded
      assert_match "joe.smith@example.com",             email.encoded
      assert_match @registration.birthday_formatted,    email.encoded
      assert_match "Anytown, NY",                       email.encoded
      assert_match "Example University",                email.encoded
      assert_match "1st Year",                          email.encoded
      assert_match "This is my 1st hackathon!",         email.encoded
      assert_match "Development",                       email.encoded
      assert_match "L",                                 email.encoded
      assert_match "Not provided",                      email.encoded
      assert_match "Peanut allergy",                    email.encoded
    end
  end

end