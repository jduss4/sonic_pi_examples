use_bpm 76
load_sample :ambi_glass_rub
load_sample :ambi_lunar_land
load_sample :loop_breakbeat

# keep track of the current chord and current playthrough
rep = 0
set = 0

chords = ring(
  [:c3, :major],
  [:e3, :major],
  [:c3, :major],
  [:g2, :major],
  [:a2, :minor],
  [:e3, :minor],
  [:eb3, :major],
  [:bb2, :major],
  [:g3, :major]
)

# give each pattern a weight
patterns = knit(
  # active rare
  [ :v, :r, :v, :r, :r, :v, :vi, :iii ], 1,
  [ :iii, :r, :iii, :ii, :r, :r, :r, :r ], 1,
  [ :iii, :r, :iii, :i, :r, :iv, :v, :r ], 1,
  # active common
  [ :i, :iv, :r, :r, :iv, :r, :v, :r ], 2,
  [ :r, :iii, :iv, :iii, :r, :ii, :r, :i ], 2,
  [ :i, :r, :i, :r, :r, :v, :iii, :ii ], 2,
  # sparse patterns
  [ :i, :r, :r, :r, :iii, :r, :v, :r ], 3,
  [ :i, :r, :r, :r, :v, :r, :r, :r ], 2,
  [ :r, :r, :r, :iv, :r, :v, :r, :i ], 2,
  # rests
  ##| [ :r, :r, :r, :r, :r, :r, :r, :r ], 3,
).shuffle


# coordinates chord changes
live_loop :metronome do
  rep = tick
  
  # if starting the pattern over, send out message
  if rep % chords.length == 0
    set = rep / chords.length
    cue :repeat_pattern
  elsif rep % chords.length == chords.length - 1
    # this is the final chord before repeating
    cue :final_chord
  end
  
  cue :change_chord
  sleep 4
end


define :amp_by_time do |total_reps, current_rep|
  # create an absolute value chart based on number of reps
  # cut the reps in half for hrep
  #           1
  # y = - (hrep + 1) * | i - hrep | + 1
  #   negative in order to flip chart /\ instead of \/
  #   1 / hrep + 1 stretches to entire time range plus 1 so that no time in range is 0 amp
  #   i - hrep to center the graph within the time range
  #   + 1 to get the amp from 0 to 1
  hrep = total_reps / 2.0
  i = current_rep.to_f
  amp = -(1.0/(hrep+1.0))*(((i+1.0)-hrep).abs)+1.0
end

# pass in octaves desired to get current chord
define :current_chord do |octaves|
  return chord chords[rep][0], chords[rep][1], num_octaves: octaves
end


live_loop :arpeggios do
  sync :change_chord
  sleep 0.25
  ch = current_chord(2)
  play_pattern_timed choose([ch, ch.shuffle]), 0.25, amp: 0.3
  sleep 0.25
  play_pattern_timed choose([ch.shuffle, ch.reverse]), 0.25, amp: 0.3
  sleep 0.5
end

live_loop :bass do
  with_synth :fm do
    sync :change_chord
    with_octave -1 do
      current = chords[rep]
      triad = chord current[0], current[1]
      num = rand_i(4)
      if num == 1
        play current[0], sustain: 1
        sleep 3.5
        play degree :ii, current[0], current[1]
      elsif num == 2
        play choose(triad), sustain: 2, release: 2
        sleep 2
        play choose(triad), sustain: 2, release: 2
      else
        play current[0], sustain: 2, release: 2
      end
    end
  end
end

live_loop :chimes do
  with_synth :growl do
    with_octave 3 do
      sync :change_chord
      # construct a chord object from the ring ( chord :e3, :major )
      ch = current_chord(1)
      8.times do |i|
        amp = amp_by_time(8, i)
        play_chord [ch[0], ch[1]], amp: amp
        sleep 0.25
        play_chord [ch[0], ch[2]], amp: amp
        sleep 0.25
      end
    end
  end
end

live_loop :glass do
  sync :change_chord
  if one_in(4)
    g = sample :ambi_glass_rub, attack: 3, release: 2, pitch: 1, amp: 0.5, amp_slide: 0.5
    sleep 1
    control g, amp: 1
    sleep 1
    control g, amp: 0.5
    sleep 0.75
    control g, amp: 0
  end
end

live_loop :landing do
  sync :final_chord
  if set > 2
    sample :ambi_lunar_land
  end
end

live_loop :noodling do
  sync :change_chord
  if set > 0
    with_octave 2 do
      with_synth :beep do
        ch = chords[rep]
        degrees = choose(patterns).map do |item|
          (item == :r) ? :r : degree(item, ch[0], ch[1])
        end
        play_pattern_timed degrees, [0.5], release: 1.5, amp: 0.5
      end
    end
  end
end

live_loop :perc do
  sync :change_chord
  if set > 0
    sample :loop_breakbeat, beat_stretch: 4
    sleep 4
  end
end
