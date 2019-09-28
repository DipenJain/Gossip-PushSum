defmodule MainProcess do

	def first(nodes,topology) do
		# a list of the PIDs of the started nodes
		listOfNodes = Enum.map(1..nodes, fn x-> elem(GenServer.start_link(WorkerNode,:ok),1) end)
		IO.inspect(listOfNodes)
		# a tuple of the PIDs of the started nodes
		tupleOfNodes = List.to_tuple(listOfNodes)
		# starting the Topologies server
		{:ok,topo} = GenServer.start_link(Topologies,[])
		# using the Topologies server to get the neighbours
		neighbours = GenServer.call(topo,{:start_topologies,listOfNodes,topology})
		# converting the list of neighbours to a tuple
		neighbours = List.to_tuple(neighbours)
		# updating the state of every node with its neighbours
		Enum.map(0..(nodes-1), fn x -> GenServer.cast(elem(tupleOfNodes,x),{:nb,elem(neighbours,x)}) end)
		# passing message to the 1st node
		GenServer.cast(elem(tupleOfNodes,1), {:msg,"hello"})
	end

end