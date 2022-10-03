class EventJob < ApplicationJob
  queue_as :default

  def perform(event)
    case event.source
    when "stripe"
      stripe_event = Stripe::Event.construct_from(
        JSON.parse(event.request_body, symbolize_names: true)
      )
      begin
        handle_stripe(stripe_event)
        event.update(
          event_type: stripe_event.type,
          error_message: '',
          status: :processed
        )
      rescue => e
        event.update(
          error_message: e.message,
          status: :failed)
      end
    else
      event.update(
        error_message: "Unknown source #{stripe_event.source}",
        status: :failed)
    end
  end

  def handle_stripe(event)
    case event.type
    when "account.updated"
      account = event.data.object
      user = User.find_by(stripe_account_id: account.id)
      user.update(charges_enabled: account.charges_enabled)
    when "checkout.session.completed"
      checkout_session = event.data.object
      reservation = Reservation.find_by(session_id: checkout_session.id)
      if reservation.nil?
        raise "No reservation found with Checkout Session ID #{checkout_session.id}"
      end
      reservation.update(status: :booked, stripe_payment_intent_id: checkout_session.payment_intent)
    when "checkout.session.expired"
      checkout_session = event.data.object
      reservation = Reservation.find_by(session_id: checkout_session.id)
      if reservation.nil?
        raise "No reservation found with Checkout Session ID #{checkout_session.id}"
      end
      reservation.update(status: :expired)
    when "charge.refunded"
      charge = event.data.object
      reservation = Reservation.find_by(stripe_payment_intent_id: charge.payment_intent)
      if reservation.nil?
        raise "No reservation found with Payment Itent ID #{charge.payment_intent.id}"
      end
      reservation.update(status: :cancelled)
    end
  end
end
