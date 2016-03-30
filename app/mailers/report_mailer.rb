class ReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.send_report.subject
  #
  def send_report(url, address)
    @greeting = "Hi"
    @url = url
    mail to: address, subject: "The report you requested!"
  end
end
