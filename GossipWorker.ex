defmodule WorkerNode do
	use GenServer

	def start_link(opts) do
		# every server that is started, this method is called
		# i can pass the neighbours when i start the server
		GenServer.start_link(__MODULE__,:ok,opts)
	end


	def init(:ok) do
		{:ok,%{:count=>0,:nb=>[]}}
	end

	# when node receives a message, it sends to a random neighbour
	def handle_cast({:msg, msgContent},names) do
		
		currCnt = elem(Map.fetch(names,:count),1)
		
		#if currCnt == 0 do:
		#Send a msg to parent node saying Received.
		
		IO.inspect(self())
		IO.inspect(currCnt)
		currCnt = currCnt + 1
		names = Map.put(names,:count,currCnt)
		if currCnt < 10 do
			neighbours = elem(Map.fetch(names,:nb),1)
			neighbours = List.to_tuple(neighbours)
			nb_size = tuple_size(neighbours)
			rand_index = :rand.uniform(nb_size) - 1
			GenServer.cast(elem(neighbours,rand_index), {:msg,"hello"})
		else
			# kill the node here
			System.halt(0)
		end
		{:noreply,names}
	end


	# updates the neighbours of the node
	def handle_cast({:nb, neighbours},names) do
		names = Map.put(names,:nb,neighbours)
		{:noreply,names}
	end


	def broadcast_msg(server) do
		# interacts with topologies and gets the neighbours
		# runs loop and calls cast on all the neighbours
		GenServer.cast(server,{:msg,"Hello"})
	end

	# not needed right now
	def handle_call({:msg, name}, _from, names) do
		{:reply, Map.fetch(names,:nb), names}
	end

end
