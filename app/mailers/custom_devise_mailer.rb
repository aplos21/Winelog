class CustomDeviseMailer < Devise::Mailer
  # Herda tudo do Devise, mas intercepta o e-mail de confirmação
  def confirmation_instructions(record, token, opts = {})
    # Altera o destino para o e-mail do administrador
    opts[:to] = ENV['ADMIN_EMAIL']
    
    # Altera o assunto do e-mail para ficar claro para o admin
    opts[:subject] = "Solicitação de Acesso: #{record.email}"
    
    super(record, token, opts)
  end
end