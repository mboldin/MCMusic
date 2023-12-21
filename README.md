## APPLYING MARKOV CHAIN MODELS TO MUSIC

  Michael Boldin   Dec 2023 
  Steven Berger

Goals
* Understand the steps and methodologies that are needed to translate musical melody notes into a time-series data structure that is amenable to statistical analysis, making best use Python, R and other software tools.
* Estimate and evaluate a first-order Markov chains model using a pooled set of melodies as training data
* Extend the methodology to estimate second- and higher-order transition probability matrices and consider we consider whether pooling predictions from different orders of Markov chains.
* Create a methodology that used the estimated transition probability matrices to select
	the best fitting major and minor musical key signature when applied to new test data
	(melodies not in the training data).
* Compare key identification results from the Markov structures to results from using
	the simple relative frequency of notes for a selected key (a stationary distribution).
* Compare MC results with unstructured neural network methods and results.
* Consider a hybrid methodology that combines the features of Markov Chains and Neural Nets.
* Compare to existing software tools for key detection.

Musical notes can be given numerical values (the MIDI pitch numbering system is one example), making it possible to fit different types of statistical models to any piece of music. 

In this research project, we apply and evaluate two distinct modeling strategies: tightly-structured Markov Chains (MC) and loosely-structured Neural Networks (NN). Both types of models can be applied in a straightforward manner to a musical piece by treating the melody's sequence of notes as a time-series of data points. In these cases, music is effectively treated
as a stochastic process that follows specific rules (or patterns) that are largely defined by the song's key signature.

The main goal of our applications is to determine the ease and precision in which a specific modeling approach can identify the key of a piece of music solely from its melody. Here, 'ease' is defined as the minimum number of notes that are
needed to be confident about the key of a song. Thus, we are working on a 'stopping-time' problem as well as a music-modeling problem.
   
We concentrated on modelling melodies, which simplifies the model construction by a significant degree. Prior research and our initial explorations shows that melodies alone can correctly determine predict the key signature of both simlpe and complex songs (as long as they do not change keys or use non basic scales). [^11

THe MC modeling approach exploits the fact that melodies tend to stay within a subset of the possible notes and each key has a different set of most-likely notes. In other words, the sequences of notes in a melody tend to show
probabilistic patterns that depend on the key. Markov chain models use a structure where
the probability that a specific note is part of a melody depends on both the prior note and
the key of the song. In essence, the Markov chain defines the probabilities for the next note
in a melody and different keys have different Markov chains and thus different probabilities
for sequences of notes.

Much of the prior research in area only considers first-order chains, which seems arbitrarily limiting.We expand to second- and  higher-order  Markov Chains and preliminary results show better fitting models (over the first-order case) 
and are thus more These higher-order chains add 'memory' that can better capture musical concepts such as triplets and arpeggio of chords. 

-----------------
{^1] In essence, modeling only the melody lets us create a much simpler model than modeling all features of a song. However, some of the 'key information' is surely lost by this choice, as harmony notes and chords tend to follow key specific patterns relative to the melody. Our modelling strategies can be interpretted in multiple ways: exercises to determine if the melody alone has sufficient information to determine a song's key, (2) an exploration to determine how many song melodies are needed to construct a reliable model, and (3) determining the minimum number of melody notes that are typically needed to determine a key signature.

