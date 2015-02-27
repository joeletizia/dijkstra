require 'pry'

class Edge
  def initialize(destination, weight)
    @destination = destination
    @weight = weight
  end

  attr_accessor :destination, :weight
end

lines = File.open("./small_test.txt", "r").readlines

edges = {}

lines.each do |line|
  line_items = line.split(" ")
  vertex = line_items[0].to_i

  unless line_items[1...line_items.length].nil?
    line_items[1...line_items.length].each do |pair|
      destination, weight = pair.split(",").map(&:to_i)
      edges[vertex] ||= []
      edges[vertex] << Edge.new(destination, weight)
      edges[destination] ||= []
      edges[destination] << Edge.new(vertex, weight)
    end
  end
end

def min_distance_destination(edges, source, available_nodes)
  place_to_go = nil
  min = nil
  edges.each do |edge|
    if edge.v1 == source
      destination = edge.v2
      if available_nodes.include? destination
        place_to_go = destination if min.nil? || min > edge.weight
      end
    end

    if edge.v2 == source
      destination = edge.v1
      if available_nodes.include? destination
        place_to_go = destination if min.nil? || min > edge.weight
      end
    end
  end

  place_to_go
end

def distance_between(edges, source, destination)
  edges[source].each do |edge|
    return edge.weight if edge.destination == destination
  end

  raise "There is no connection between the two nodes #{source} and #{destination}"
end

def dijkstra(edges, source)
  distances = {}
  edges.keys.each do |key|
    distances[key] = Float::INFINITY
  end
  distances[source] = 0

  visited = []
  unvisited = edges.keys

  current_node = source
  current_traveled_distance = 0
  traveled_path = {}
  current_traveled_path = []

  binding.pry

  while unvisited.any?
    neighbor_edges = edges[current_node]

    node_to_move_to = nil
    min_travel_distance_to_next_node = Float::INFINITY

    neighbor_edges.each do |neighbor_edge|
      if neighbor_edge.weight < min_travel_distance_to_next_node && unvisited.include?(neighbor_edge.destination)
        min_travel_distance_to_next_node = neighbor_edge.weight
        node_to_move_to = neighbor_edge.destination
      end

      if distances[neighbor_edge.destination] > neighbor_edge.weight + current_traveled_distance
        distances[neighbor_edge.destination] = current_traveled_distance + neighbor_edge.weight
        traveled_path[neighbor_edge.destination] = current_traveled_path + [current_node, neighbor_edge.destination]
      end
    end

    binding.pry

    visited << current_node
    current_traveled_path << current_node
    unvisited.delete(current_node)

    break if min_travel_distance_to_next_node == Float::INFINITY
    current_traveled_distance += edges[current_node].select{|node| node.destination == node_to_move_to}.first.weight
    current_node = node_to_move_to
  end
  [distances, traveled_path]
end

def output_format(distances_hash, paths_hash)
  distances_hash.each do |node, distance_traveled|
    path = paths_hash[node] ? paths_hash[node] - [1]: []
    puts "#{node} #{distance_traveled} #{path}"
  end
end

def big_output_format(distances_hash, paths_hash)
  nodes_to_output = [10,30,50,80,90,110,130,160,180,190]

  nodes_to_output.each do |node|
    path = node ? paths_hash[node] - [1]: []
    puts "#{node} #{distances_hash[node]} #{path}"
  end
end


x = dijkstra(edges, 1)
binding.pry
output_format(x.first, x[1])
binding.pry
