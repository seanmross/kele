require 'httparty'
require 'json'
require_relative 'roadmap'

class Kele
  include HTTParty
  include Roadmap
  BASE_URI = 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    response = self.class.post("#{BASE_URI}/sessions", body: { "email": email, "password": password })
    raise "Invalid email or password" if response.code != 200
    @kele_client = JSON.parse(response.body)
    @auth_token = response["auth_token"]
    @user_id = response["user"]["id"]
  end

  def get_me
    response = self.class.get("#{BASE_URI}/users/me", headers: { "authorization" => @auth_token })
    raise "Invalid authorization" if response.code != 200
    @user = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("#{BASE_URI}/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    raise "Invalid mentor id" if response.code != 200
    @mentor_availability = JSON.parse(response.body)
  end

  def get_messages(page = nil)
    if page.nil?
      response = self.class.get("#{BASE_URI}/message_threads", headers: { "authorization" => @auth_token })
    else
      response = self.class.get("#{BASE_URI}/message_threads?page=#{page}", headers: { "authorization" => @auth_token })
    end
    raise "Invalid page number" if response.code != 200
    @messages = JSON.parse(response.body)
  end

  def create_message(recipient_id, subject, message)
    response = self.class.post("#{BASE_URI}/messages", body: { "user_id": @user_id, "recipient_id": recipient_id, "subject": subject, "stripped-text": message }, headers: { "authorization" => @auth_token })
    raise "Invalid message" if response.code != 200
    puts response
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    response = self.class.post("#{BASE_URI}/checkpoint_submissions", body: { "enrollment_id": 22463, "checkpoint_id": checkpoint_id, "assignment_branch": assignment_branch, "assignment_commit_link": assignment_commit_link, "comment": comment }, headers: { "authorization" => @auth_token })
    raise "Invalid submission" if response.code != 200
    puts response
  end

end
