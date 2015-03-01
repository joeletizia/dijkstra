require 'pry'

class Edge
  def initialize(destination, weight)
    @destination = destination
    @weight = weight
  end

  attr_accessor :destination, :weight
end

lines = File.open("./dijkstraData.txt", "r").readlines

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

def vertex_with_min_distance(edges, distances, unvisited)
  min = Float::INFINITY
  node_to_visit = nil

  unvisited.each do |unvisited_node|
    if distances[unvisited_node] < min
      min = distances[unvisited_node] 
      node_to_visit = unvisited_node
    end
  end

  node_to_visit
end

def dijkstra(edges, source)
  distances = {}
  previous = {}
  unvisited = []

  distances[source] = 0
  previous[source] = nil

  edges.each do |node, edge_array|
    unless source == node
      distances[node] = Float::INFINITY
      previous[node] = nil
    end

    unvisited.push node
  end

  u = source

  while unvisited.any?
    u = vertex_with_min_distance(edges, distances, unvisited)
    puts "#{u} is closest. Deleteing #{u}"
    unvisited.delete(u)

    puts "#{unvisited.count} left unvisited"
    if edges[u]
      edges[u].each do |edge|
        alt = distances[u] + edge.weight
        if alt < distances[edge.destination]
          distances[edge.destination] = alt
          previous[edge.destination] ||= []
          previous[edge.destination] << u
        end
      end
    end

  end

  return [distances, previous]
end

def output_format(distances_hash, paths_hash)
  distances_hash.each do |node, distance_traveled|
    path = paths_hash[node] ? paths_hash[node] - [1]: []
    puts "#{node} #{distance_traveled} #{path}"
  end
end

def big_output_format(distances_hash, paths_hash)
  nodes_to_output = [7,37,59,82,99,115,133,165,188,197]

  nodes_to_output.each do |node|
    path = node ? paths_hash[node] - [1]: []
    puts "#{node} #{distances_hash[node]} #{path}"
  end
end

def big_output_format_dist(distances_hash, paths_hash)
  nodes_to_output = [7,37,59,82,99,115,133,165,188,197]

  nodes_to_output.each do |node|
    path = node ? paths_hash[node] - [1]: []
    puts "#{node} #{distances_hash[node]}"
  end
end



x = dijkstra(edges, 1)
binding.pry
big_output_format_dist(x.first, x[1])
binding.pry
