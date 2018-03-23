class Api::V5::UnauthController < Api::V5::BaseController
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
If this ever happens, you just need to send us the Transaction ID at support.uk@alldealzz.com and we will get back to you with the solution as soon as possible. Generally, we will make the deal code available if the payment has been successful or issue a refund.
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
    render_success(text: '<p>All Dealzz (All Dealzz UK Ltd) is a mobile application that helps you to save money by offering amazing deals from nearby restaurants, cafes, spa, salon, gym, medical, grocery, apparel and much more!</p>
<p><br /><strong>Location Based Notifications:</strong></p>
<p>Whenever you are near a restaurant or any store that has an active deal, you will automatically get a notification about the deal given that you have chosen the category as your preference in the All Dealzz app. Example &ndash; &ldquo;You are just few steps away from 30% discount @ The Coffee Shop&rdquo;<br /><br /><strong>Exclusive Deals:</strong></p>
<p>These type of deals are specially catered for the All Dealzz app users exclusively which you cannot find anywhere else.</p>
<p><strong>Last Minute Deals:</strong></p>
<p>These deals are made active by merchants for only few hours. If you are early enough, you can easily purchase the deal and avail it. The clock will be ticking, so you always need to hurry for the awesome last minute deals!</p>
<p><strong>Upcoming Deals:</strong></p>
<p>Now, you can easily know which deals are going to become live in the near future for a particular store. Use this feature to plan your next usage of those particular deals.</p>
<p>Is this much description enough to convince you?</p>
<p>Well, if not, then we still have tons of other useful features to convince you.</p>
<p>- Follow your favourite stores and restaurants to always stay notified of their deals changes, new deal launches and promotions<br />- When you book a deal, you get an option to remind you to redeem that deal on any particular day you wish to avail it<br />- You can add deals to your Favourites list inside the app to decide later of booking or purchasing those offers<br />- You can sort all deals through various options like Nearby, Bestsellers, Views and Upcoming</p>
<p>We hope it pretty much convince you!</p>
<p><strong>Payments &amp; Transactions:</strong></p>
<p>You can easily see the list of your booked and purchased deals in the My Deals section of the app. Also, you will be able to check the transactions history.</p>
<p><strong>Location Tracking:</strong></p>
<p>Surprise! The app does not track your whereabouts and share it to the server continuously. With advanced algorithms integrated, All Dealzz sends you location based notifications without sharing the device location.</p>
<p><strong>How to Redeem a Deal:</strong></p>
<p>Its very simple. On successful booking or purchase of a deal, you will get a code on your registered email and also on the app in My Deals sections. Simply, take this code to the merchant and avail the deal.</p>
<p>If somehow the merchant is not able to process, then you can Self-Redeem the deal in front of the merchant and its done!<br /><br />Get the Right Deals at the Right Time with All Dealzz !</p>
<p>All Dealzz is currently available in United Kingdom.</p>
<p><strong>INTELLECTUAL PROPERTY</strong></p>
<p>All the intellectual property used in developing, maintaining and marketing the All Dealzz platform for United Kingdom is solely under All Dealzz UK Ltd only.&nbsp;</p>
<p><strong>LIMITATION OF LIABILIITES</strong></p>
<p>All Dealzz is a platform used to connect the hyper local stores with the customers through an interactive medium. All Dealzz is not liable for any product/service sold by any of the merchants on the All Dealzz platform via the mobile application post purchase or availing the said service or products. We are just a connecting tool between the merchants and the customers and make the entire process smooth and as fast as possible.&nbsp;</p>
<p><strong>DISCLAIMER</strong></p>
<p>All Dealzz makes use of your location on a timely basis to offer you the best deals around you and send you notifications based on your interest and location. We also collect some personal information like gender, age, phone number and email only to send you information related to All Dealzz and some promotional offers that may seems to be of interest based on your demographics.&nbsp;</p>
<p><strong>CONTACT US</strong></p>
<p>We can always be reached at <a href="mailto:support.uk@alldealzz.com">support.uk@alldealzz.com</a> . If you still have any more queries, then please drop us a mail on our registered office address at:</p>
<p>Flat 308 California Building,</p>
<p>Lewisham London, SE13 7SF, UK</p>
<p>Last Updated On: 7<sup>th</sup> December, 2016 www.alldealzz.com</p>
<p><br /><br /></p>')
  end

  def privacy_policy
    render_success(text: '<ul>
   <li>
      <h5>What Personal Information Does All Dealzz Collect?</h5>
      <p>
         Your phone number.
         <br> Your location information from time to time.
         <br> Any personal information that you choose to provide such as name, email, gender.
         <br>
      </p>
   </li>
   <li>
      <h5>Why is this information collected?</h5>
      <p>
         Your Services account will be associated with your phone number and this account will be used for all our Services that you use.The contact information you provide may be used by All Dealzz to send you timely and relevant promotions. By accepting this privacy policy, you give All Dealzz the right to contact you by SMS or e-mail for such promotions.
      </p>
      <p>
         All Dealzz provides you, the user, with deals in various categories which are highly customized to your location, indicated tastes and probable use. Since the deals are tim-sensitive, we need to collect the above information on a periodic basis. Your contact information is collected in order to enable you to share the deals that you discover on our platform with your friends at real-time.
      </p>
   </li>
   <li>
      <h5>How is My Information Shared?</h5>
      <p>
         Personal Information about our users is an integral part of our business. We neither rent nor sell your identifiable personal Information to anyone.
      </p>
   </li>

   <li>
      <h5>Determining your location.</h5>
      <p>
         The Services deal with location, so in order to work, the Services need to know your location. Whenever you open and use/interact with our apps on your mobile device or go to one of our Sites, we use the location information from your mobile device or browser (e.g., latitude and longitude) to tailor the Services experience to your current location (i.e., we will show you a list of nearby locations, friends and tips). This information is NOT shared in a form that is identified with you with others unless you are using a service that they offer.
      </p>
   </li>
   <li>
      <h5>Sharing Location with the All Dealzz app.</h5>
    <p>
        Your real-time location is not shared with anyone on the All Dealzz app in any form that identifies you.
    </p>
   </li>
</ul>
')
  end

  def terms_and_conditions
    render_success(text: '<p align="center">
    <strong>Terms And Conditions</strong></p>
      <ul>
         <li>
            <h5>Your Acceptance</h5>
            <p>
               This is an agreement between All Dealzz. and you , a user of the Service. BY USING THE SERVICE, YOU ACKNOWLEDGE AND AGREE TO THESE TERMS OF SERVICE, AND ALL DEALZZ PRIVACY POLICY, WHICH CAN BE FOUND AT http://www.alldealzz.com/privacy/, AND WHICH ARE INCORPORATED HEREIN BY REFERENCE. If you choose to not agree with any of these terms, you may not use the Service.
            </p>
         </li>
         <li>
            <h5>All Dealzz Access</h5>
            <ul>
               <li>
                  Subject to your compliance with these Terms of Service, All Dealzz hereby grants you permission to use the Service, provided that:
                  <ul>
                     <li>your use of the Service as permitted is solely for your personal use, and you are not permitted to resell or charge others for use of or access to the Service, or in any other manner inconsistent with these Terms of Service;</li>
                     <li>you will not duplicate, transfer, give access to, copy or distribute any part of the Service in any medium without All Dealzz prior written authorization;</li>
                     <li>you will not attempt to reverse engineer, alter or modify any part of the Service; and</li>
                     <li>you will otherwise comply with the terms and conditions of these Terms of Service and Privacy Policy.</li>
                  </ul>
               </li>
               <li>
                  <strong> In order to access and use the features of the Service, you acknowledge and agree that you will have to provide All Dealzz with your mobile phone number.</strong>  When providing your mobile phone number, you must provide accurate and complete information. You must notify All Dealzz immediately of any breach of security or unauthorized use of your mobile phone. Although All Dealzz will not be liable for your losses caused by any unauthorized use of your account, you may be liable for the losses of All Dealzz or others due to such unauthorized use.
               </li>
               <li>
                  You agree not to use or launch any automated system, including without limitation, robots, spiders, offline readers, etc. or load testers such as wget, apache bench, mswebstress, httpload, blitz, Xcode Automator, Android Monkey, etc., that accesses the Service in a manner that sends more request messages to the All Dealzz servers in a given period of time than a human can reasonably produce in the same period by using a All Dealzz application, and you are forbidden from ripping the content unless specifically allowed. Notwithstanding the foregoing, All Dealzz grants the operators of public search engines permission to use spiders to copy materials from the website for the sole purpose of creating publicly available searchable indices of the materials, but not caches or archives of such materials. All Dealzz reserves the right to revoke these exceptions either generally or in specific cases. While we do not disallow the use of sniffers such as Ethereal, tcpdump or HTTPWatch in general, we do disallow any efforts to reverse-engineer our system, our protocols, or explore outside the boundaries of the normal requests made by All Dealzz clients. We have to disallow using request modification tools such as fiddler or whisker, or the like or any other such tools activities that are meant to explore or harm, penetrate or test the site. You must secure our permission before you measure, test, health check or otherwise monitor any network equipment, servers or assets hosted on our domain. You agree not to collect or harvest any personally identifiable information, including phone number, from the Service, nor to use the communication systems provided by the Service for any commercial solicitation or spam purposes. You agree not to spam, or solicit for commercial purposes, any users of the Service.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         </li>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     </ul>
         </li>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           <li>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           <h5>Intellectual Property Rights</h5>
            <p>
               The design of the All Dealzz Service along with all associated properties, are owned by or licensed to All Dealzz, subject to copyright and other intellectual property rights under Indian Law. The Service is provided to you AS IS for your information and personal use only.All Dealzz reserves all rights not expressly granted in and to the Service. You agree to not engage in the use, copying, or distribution of any of the Service other than expressly permitted herein, including any use, copying, or distribution of Status Submissions of third parties obtained through the Service for any commercial purposes.
            </p>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           </li>
         <li>
            <h6>All Dealzz permits you to link to materials on the Service for personal purposes only. All Dealzz reserves the right to discontinue any aspect of the All Dealzz Service at any time.</h6>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           </li>
      </ul>
    ')
  end
end  