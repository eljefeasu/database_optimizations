class ReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.send_report.subject
  #
  def send_report(path, address)
    @greeting = "Hi"
    @path = path
    attachments['report.csv'] = File.read(path)
    mail to: address, subject: "The report you requested!"
  end
end
