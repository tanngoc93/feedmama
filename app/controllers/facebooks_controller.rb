class FacebooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  PAGE_ID = ENV.fetch('PAGE_ID')
  VERIFY_TOKEN = ENV.fetch('VERIFY_TOKEN')
  SECURE_TOKEN = ENV.fetch('SECURE_TOKEN')
  KOALA_TOKEN = ENV.fetch('KOALA_GPT_TOKEN')
  KOALA_PAGE_ACCESS_TOKEN = ENV.fetch('KOALA_PAGE_ACCESS_TOKEN')

  def subscription
    return unless params[:secure_token] == SECURE_TOKEN

    if(realtime_request?(request))
      case request.method
      when "GET"
        challenge = Koala::Facebook::RealtimeUpdates.meet_challenge(params, VERIFY_TOKEN)

        if(challenge)
          render :plain => challenge
        else
          render :plain => 'Failed to authorize facebook challenge request'
        end
      when "POST"
        data = params['entry'][0]['changes'][0]['value']

        comment = data['message']
        comment_id = data['from']['id']
        commenter_name = data['from']['name']

        return if comment.nil? || comment_id.nil? || comment_id == PAGE_ID

        if new_comment?(data)
          Rails.logger.debug('>>>>> REPLY')

          @page = Koala::Facebook::API.new( KOALA_PAGE_ACCESS_TOKEN )
          reply_message = ask_koala_gpt(comment, commenter_name)
          @page.put_comment(data['comment_id'], reply_message)
        else
          Rails.logger.debug('>>>>> SKIP')
        end

        render :plain => 'Thanks for the update.'
      end
    end
  rescue StandardError => e
    Rails.logger.debug(">>>>> #{e.message}")
  end

  private

  def realtime_request?(request)
    ((request.method == "GET" && params['hub.mode'].present?) ||
       (request.method == "POST" && request.headers['X-Hub-Signature'].present?))
  end

  def new_comment?(data)
    data['item'] == 'comment' && data['verb'] == 'add'
  end

  def ask_koala_gpt(message = '', commenter_name = '')
    conn = Faraday.new(
      url: 'https://koala.sh/api/gpt/',
      headers: {
        'Authorization': "Bearer #{ KOALA_TOKEN }",
        'Content-Type': 'application/json'
      }
    )

    input = "Please help me write a creative/engaging comment to reply to this comment #{message}. The commenter's name is #{commenter_name}. \n- Let's analyze the feelings of this comment first. \n- Depend on the emotion of the comment and reply to them with appreciation, gratitude or an empathetic comment. \n- Be kind/energetic and full of love. \n- And if possible choose an icon for the comment you make, it should match the emotion of the comment, for example the comment's emotion is positive, happy should not choose the sad symbol, and vice versa. \n- Make it 10 to 30 words long. \n- If the message is blank or you can't understand the context, give the person a cute song. \n- Note: My Facebook page represents www.AllLoveHere.com, an online store dedicated to custom jewelry as gifts for various occasions and for a wide audience, mainly between family members and their friends. \n- Place the following text at the end to indicate that you are a GPT bot: \" (I'm a Bot. If I make any mistakes, please forgive me. You can find me at www.AllLoveHere.com)\""

    response = conn.post do |req|
      req.body = {
        input: input,
        inputHistory: [],
        outputHistory: [],
        realTimeData: false,
      }.to_json
    end

    puts
    puts '>>>>> Koala GPT Processing <<<<<'
    puts "status: #{response.status}"
    puts "headers #{response.headers}"
    puts "comment #{message}"
    puts "body:   #{response.body}"
    puts '>>>>> Koala GPT Processed <<<<<'
    puts

    JSON.parse(response.body)['output']
  rescue StandardError => e
    puts "Line 90 : #{e.message}"
  end
end
