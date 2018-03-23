class Api::V2::UnauthController < Api::V2::BaseController
  def faq
    render_success(text: '<p align="center">
<strong>FREQUENTLY ASKED QUESTIONS</strong>
</p>
<p>
<strong></strong>
</p>
<p>
<em>1. </em>
<em>Are all the coupons and deals free in this app?</em>
</p>
<p>
Yes. We have made all the coupons and the deals listed on the All Dealzz app free to the users.
</p>
<p>
<em>2. </em>
<em>Are the deals verified?</em>
</p>
<p>
Yes. Our account managers seamlessly take care of the validity and authenticity of the deal before publishing it on the app
</p>
<p>
<em>3. </em>
<em>How do I get notifications based on the nearness to a store or restaurant?</em>
</p>
<p>
Whenever you are near to a store or a restaurant for a while, the app notices it via your location and gives you an notification about the latest deal from
that store
</p>
<p>
<em>4. </em>
<em>Does it mean I am being tracked continuously? </em>
</p>
<p>
The answer is No. We have integrated advanced algorithms that doesn’t send your location to the server whenever a notification is fetched and doesn’t
update it every second.
</p>
<p>
<em>5. </em>
<em>How much is my privacy secured?</em>
</p>
<p>
Its totally safe. Our servers are highly secured and your location always remains anonymous.
</p>
<p>
6. <em>What if I am denied a deal listed on the app?</em>
</p>
<p>
This is highly unlikely to happen. In case it happens, we request you to send us a direct message from the app via the Feedback form and we will see to its
core.
</p>
<p>
<em>7. </em>
<em>I am a retailer or a restaurant owner. How can I list my deals on your app?</em>
</p>
<p>
Its very simple. Just leave us a message through the app or our website alldealzz.com and we will get in touch with you as soon as possible.
</p>
<p>
<em>8. </em>
<em>What are the Internet Handling Charges that show up during purchasing a deal by making direct payment?</em>
</p>
<p>
Well, to say it in simple words, that is how me make money! Its our fair share of providing the service to the app users.
</p>
<p>
<em>9. </em>
<em>What if a transaction goes wrong and I do not get a code to redeem the deal?</em>
</p>
<p>
If this ever happens, you just need to send us the Transaction ID at support@alldealzz.com and we will get back to you with the solution as soon as possible. Generally, we will make the deal code available if the payment has been successful or issue a refund.
</p>
<p>
<em>10. </em>
<em>Can I cancel/refund my purchased deal order?</em>
</p>
<p>
Sorry. This is not possible. Once you have purchased a deal, you will need to go to the particular venue to avail the service or product. If the service or product is not available, you have the right to ask the merchant to settle the amount for another product or service pertaining to the terms and conditions of the merchant. You cannot ask for direct cash payment as refund.
</p>')
  end

  def about_us
    render_success(text: '<p align="center">
Copyright &copy; 2016 . AppNxt Ideas Pvt. Ltd. All Rights Reserved.
</p>')
  end
end  