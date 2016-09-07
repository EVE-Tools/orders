defmodule Element43.Orders.NSQClient do
  use GenServer

  @doc """
    Wrap start_link.
  """
  def start_link do
    GenServer.start_link(__MODULE__, [], name: {:global, :nsq_publisher})
  end

  @doc """
    Initialize server and open NSQ connection.
  """
  def init(_params) do
    {:ok, consumer} = NSQ.Consumer.Supervisor.start_link("orders", "orders",
      %NSQ.Config{
        nsqds: [Config.get(:element43_orders, :nsqd)],
        max_in_flight: 2500,
        message_handler: Element43.Orders.NSQClient
      })

    {:ok, consumer}
  end

  @doc """
    Send message to storage service.
  """
  def handle_message(body, _msg) do
    GenServer.call({:global, :order_store}, {:store_market, body}, 10_000)
  end
end
