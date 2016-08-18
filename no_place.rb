# No Place
#
# Coded by Jessica Dussault jduss4

use_bpm 100
use_synth :beep

define :theme1 do
  play_pattern_timed [:g4, :a4, :g4, :fs4, :g4], [0.5, 1, 0.5]
  play_pattern_timed [:fs4], [0.5]
  play_pattern_timed [:e4, :d4], [2], release: 2
  play_pattern_timed [:g4, :g4, :g4], [0.5, 1]
  play_pattern_timed [:fs4, :g4], [1]
  play_pattern_timed [:a4], [2], release: 2
end

define :theme2 do
  play_pattern_timed [:d4, :d4], [0.5]
  play_pattern_timed [:fs4, :fs4, :fs4, :fs4], [0.5, 1, 0.5, 0.5]
  play_pattern_timed [:e4, :d4], [1, 0.5]
  play_pattern_timed [:g4, :g4, :g4, :g4], [0.5, 1, 0.5, 0.5]
  play_pattern_timed [:a4, :b4], [1, 0.5]
  play_pattern_timed [:a4, :e4, :e4, :e4, :fs4], [0.5, 1, 0.5, 0.5, 1]
  play_pattern_timed [:g4], [0.5]
  play_pattern_timed [:a4], [2], release: 2
end

define :theme3 do
  play_pattern_timed [:g4, :a4, :g4, :fs4, :g4], [0.5, 1, 0.5]
  play_pattern_timed [:fs4], [0.5]
  play_pattern_timed [:e4, :d4], [2], release: 2
  play_pattern_timed [:g4, :g4, :g4], [0.5, 1]
  play_pattern_timed [:a4, :b4], [1]
  play_pattern_timed [:c4], [2], release: 2
end

define :theme4 do
  play_pattern_timed [:d4, :d4], [0.5]
  play_pattern_timed [:fs4, :fs4, :fs4, :fs4], [0.5, 1, 0.5, 0.5]
  play_pattern_timed [:e4, :d4], [1, 0.5]
  play_pattern_timed [:g4, :g4, :g4, :g4], [0.5, 1, 0.5, 0.5]
  play_pattern_timed [:a4, :b4], [1, 0.5]
  play_pattern_timed [:a4, :e4, :g4], [0.5, 1, 0.5]
  play_pattern_timed [:fs4, :d4], [1]
  play_pattern_timed [:g4], [2], release: 2
end

define :harmony1 do
  play_pattern_timed [:g2, :d3, :g2, :d3, :cs3, :e3], [1]
  play_pattern_timed [:g3, :e3, :d3], [0.5, 1, 0.5]
  play_pattern_timed [:g2, :d3, :g2, :d3, :cs3, :cs3, :d3], [1]
end

define :harmony2 do
  sleep 1
  play_pattern_timed [:d3, :a2], [1]
  play_pattern_timed [:d3, :d3, :c3, :a2], [0.5]
  play_pattern_timed [:b2, :d3], [1]
  play_pattern_timed [:b2, :g2, :a2, :d3], [0.5]
  play_pattern_timed [:cs3, :a2, :cs3], [1]
  play_pattern_timed [:d3, :e3], [0.5]
  play_pattern_timed [:d3, :fs3], [0.5, 1]
  play_pattern_timed [:e3, :d3, :e3, :fs3, :d3], [0.5]
end

define :harmony3 do
  play_pattern_timed [:g2, :d3, :g2, :d3, :cs3, :e3], [1]
  play_pattern_timed [:g3, :e3, :d3], [0.5, 1, 0.5]
  play_pattern_timed [:g2, :d3, :g2, :d3], [1]
  in_thread do
    play_pattern_timed [:c4, :b3, :a3], [1]
  end
  play_pattern_timed [:c3, :g2, :c3], [1]
end

define :harmony4 do
  sleep 1
  play_pattern_timed [:d3, :a2], [1]
  play_pattern_timed [:d3, :d3, :c3, :a2], [0.5]
  play_pattern_timed [:b2, :d3], [1]
  play_pattern_timed [:b2, :g2, :a2, :d3], [0.5]
  play_pattern_timed [:cs3, :a2, :d3], [1]
  play_pattern_timed [:e3, :fs3], [0.5]
  play_chord chord(:g2, :major), release: 3
  sleep 4
end

define :outro do
  play_chord chord(:eb3, :major), release: 2
  sleep 2.5
  play_pattern_timed [:eb3, :eb3], [0.24]
  play_pattern_timed [:eb3, :eb3, :eb3], [1.0/3]
  play_chord chord(:f3, :major), release: 2
  sleep 2.5
  play_pattern_timed [:f3, :f3], [0.24]
  play_pattern_timed [:f3, :f3, :f3], [1.0/3]
  play_chord chord(:g3, :major), release: 4
end

in_thread do
  theme1
end
harmony1

in_thread do
  theme2
end
harmony2

in_thread do
  theme3
end
harmony3

in_thread do
  theme4
end
harmony4

outro