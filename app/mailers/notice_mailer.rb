class NoticeMailer < ActionMailer::Base
  default from: "admin@example.com"

  def sendmail_share(share_item, to_user)
    @item = share_item
    @from_user = share_item.own_user
    @to_user = to_user
    @url = toshare_items_url

    mail ({ to: to_user.email, subject: 'Droboxからのお知らせ' })

  end
end
