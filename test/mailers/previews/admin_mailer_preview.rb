# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer/new_user_waiting_approval
  def new_user_waiting_approval
    AdminMailer.new_user_waiting_approval
  end
end
