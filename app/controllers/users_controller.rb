class UsersController < ApplicationController
  def service
    response = open("https://auth.ut.ac.ir:8443/cas/p3/serviceValidate?service=https%3A%2F%2Fevent.ut.ac.ir%2Fusers%2Fservice&ticket=" + params[:ticket], { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE }).read
    result = Hash.from_xml(response.gsub("\n", ""))
    Rails.logger.info result
    if !result["serviceResponse"]["authenticationSuccess"].blank?
      utid = result["serviceResponse"]["authenticationSuccess"]["user"]
      user = User.find_by_email(utid + "@ut.ac.ir")
      if user.blank?
        password = SecureRandom.hex(6)
        user = User.create(email: utid + "@ut.ac.ir", password: password, password_confirmation: password, last_login: DateTime.now, verified: true)
        if !result["serviceResponse"]["authenticationSuccess"]["attributes"].blank?
          name_array = result["serviceResponse"]["authenticationSuccess"]["attributes"]["givenName"]
          surename_array = result["serviceResponse"]["authenticationSuccess"]["attributes"]["sn"]
          name_array[0].scan(/[aeiou]/).count >= 1 ? name = name_array[1] : name = name_array[0]
          surename_array[0].scan(/[aeiou]/).count >= 1 ? name = name + " " + surename_array[1] : name = name + " " + surename_array[0]
        else
          name = utid
        end
        Profile.create(name: name, user_id: user.id)
      end
      redirect_to("https://event.ut.ac.ir/#/login_jwt/" + JWTWrapper.encode({ user_id: user.id }))
    else
      redirect_to("https://event.ut.ac.ir/#/login_error/")
    end
  end
end
