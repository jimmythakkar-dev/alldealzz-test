class Api::V1::UnauthController < Api::V1::BaseController
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
</p>')
  end

  def about_us
    render_success(text: '<p align="center">
Copyright &copy; 2016 . AppNxt Ideas Pvt. Ltd. All Rights Reserved.
</p>')
  end
end  