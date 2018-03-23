require_relative './paytm/encryption_new_pg'
require_relative './paytm/checksum_tool'
require 'json'
require 'cgi'
require 'uri'
class Paytm::CallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def generate_checksum

    paytmHASH = Hash.new

    paytmHASH["MID"] = '';
    paytmHASH["ORDER_ID"] = '';
    paytmHASH["CUST_ID"] = '';
    paytmHASH["INDUSTRY_TYPE_ID"] = '';
    paytmHASH["CHANNEL_ID"] = '';
    paytmHASH["TXN_AMOUNT"] = '';
    paytmHASH["WEBSITE"] = '';

    keys = params.keys
    keys.each do |k|
      if ! params[k].empty?
        if params[k].to_s.include? "REFUND"
          next
        end
        paytmHASH[k] = params[k]
      end
    end
    mid = paytmHASH["MID"]
    order_id = paytmHASH["ORDER_ID"]
    checksum_hash = ChecksumTool.new.get_checksum_hash(paytmHASH).gsub("\n",'')
    returnJson= Hash.new

    returnJson["CHECKSUMHASH"] =  checksum_hash
    returnJson["ORDER_ID"]     =  order_id
    returnJson["payt_STATUS"]  =  1
    render json: { CHECKSUMHASH: checksum_hash, ORDER_ID: order_id, payt_STATUS: 1}
  end

  def verify_checksum
    paytmHASH = Hash.new

    keys = params.keys
    keys.each do |k|
      paytmHASH[k] = params[k]
    end
    paytmHASH = ChecksumTool.new.get_checksum_verified_array(paytmHASH)

    @encoded_json = paytmHASH.to_json
    render html: "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html;charset=ISO-8859-I\"><title>Paytm</title><script type=\"text/javascript\">function response(){return document.getElementById('response').value;}</script></head><body>Redirect back to the app<br><form name=\"frm\" method=\"post\"><input type=\"hidden\" id=\"response\" name=\"responseField\" value='#{@encoded_json}'></form></body></html>".html_safe
  end

end
