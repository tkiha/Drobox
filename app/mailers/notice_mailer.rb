class NoticeMailer < ActionMailer::Base
  default from: "admin@example.com"

  def sendmail_share(share_item, from_user, to_user)
    @item = share_item
    @from_user = from_user
    @to_user = to_user
    @url = list_to_share_url

    mail ({ to: to_user.email, subject: 'Droboxからのお知らせ' })

  end
end
