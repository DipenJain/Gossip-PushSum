defmodule Topologies do
use GenServer

	def init([]) do
        	{:ok,[]}
	end

	def start_link([]) do
		GenServer.start_link(__MODULE__,[])
	end

	def handle_call({:start_topologies,listOfNodes,topology},_from,names) do
		{:reply,get_list_neighbours(listOfNodes, topology),names}
	end

	#def handle_cast() do
	#end


	def get_list_neighbours(listOfNodes, topology) do
		neighbours = get_neighbours(listOfNodes, topology)

		numNodes = length(listOfNodes)

		Enum.reduce(0..(numNodes - 1), %{}, fn x, acc ->
	  	Map.put(acc, Enum.at(listOfNodes, x), Enum.at(neighbours, x))
		end)
	end

	def get_neighbours(listOfNodes, topology) do
		numNodes = length(listOfNodes)

		cond do
		    topology == "full network" ->
		        for i <- 0..(numNodes - 1) do 
		        	listOfNodes -- [Enum.at(listOfNodes, i)]
		    	end
		    
		    topology == "line" ->
		        for i <- 0..(numNodes - 1) do
		            neighboursList =
		                cond do
		                    i == 0 -> [i + 1]
		                    i == numNodes - 1 -> [i - 1]
		                    true -> [i - 1, i + 1]
		                end
		            [] ++ Enum.map(neighboursList, fn x -> Enum.at(listOfNodes, x) end)
		        end
		end
	end
end