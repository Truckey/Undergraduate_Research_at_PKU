# Undergraduate Research at PKU

- Auditory Working Memory: the task design and analyzing method (and codes) for the first experiment in my independent research project.
- EEG_data_processing_practice: My very first experience with cognitive neuroscience research.
- Reading: Some books and articles I've read through the process (not frequently updated).

Below is the design and data analysis pipeline for my auditory working memory experiment (also see /Auditory Working Memory).



# Auditory Working Memory Experiment Design



## Participants

- no limit on musical training
- no limit on handedness (but probably needing to analyze seperately)



## Stimuli

- two musical sequence seperated by 2000-ms silence

- each sequence containing three 250-ms piano tones (C4 to E6 (except for S2 of condition TRANSPOSITION, which may be as high as E7), 70 dB SPL, presented binaurally through air-conducting tubes with foam ear tips) presented successively without inter-tone-interval

- S1: 108 musical sequences generated by [Sibelius](http://www.sibelius.com) (probably we'll use another way)

  - tonal
  - no consecutive identical tones within a sequence
  - pitch interval between consecutive tones inferior to an octave

- S2: for the incorrect trials in condition SIMPLE, REVERSED and TRANSPOSITION:

  - one tone (at any position) changed for 2/3 semitones
  - maintaining the contour (the relative magnitude of three tones)

  for condition CONTOUR:

  - correct trials: modifying one tone of S1 by 2/3 semitones but maintaining the contour
  - incorrect trials: modifying one tone of S1 so as to change the contour (currently done by raising the 3rd tone to a pitch 2/3 semitones higher than the 1st, or lowering the 1st to that lower than the 3rd)



## Procedure

- Presentation software: [Neurobehavioral Systems](https://www.neurobs.com/presentation) (probably replaced by *Psychtoolbox*)
- Recording: 62 channels + EOG + nose reference + ground
- Trial pipeline:
  - No cue for trial beginning
  - Visual: fixating a continuously displayed cross (white on a gray background)
  - 750-ms S1
  - 2000-ms retention
  - 750-ms S2
  - 2000-ms reaction (pressing one of two buttons with right hand, no feedback)
  - 500-ms - 1000-ms randomized ITI (in order to remove the effect of expectation)
- Conditions:
  - SIMPLE: simple comparison
  - REVERSED: requiring subjects to mentally reverse S1 during retention, then compare it with S2
  - TRANSPOSITION: requiring subjects to mentally raise S1 for an octave during retention, then compare it with S2
  - CONTOUR: requiring subjects to mentally change the movement S1 into categories ("up-up" / "up-down" / "down-up" / "down-down") during retention, and that of S2 during reaction, then compare them
- Design:
  - block design
    - 2 blocks for each condition (totally 8 rather than the original 4), latin-square arrangement
    - 2-3 minutes rest between two blocks
    - each block containing 27 correct trials and 27 incorrect (totally 54 rather than the original 108), no consecutive three trials with the same response
    - totally 108 trials (rather than 216) for each condition
  - 4 * 27 practice trials (without feedback) at the very beginning, with sequences not used in formal experiments, 75% (can be a little lower considering the difficulty) accuracy required
- 10 practice trials or so before every block
- Total time estimation:
  - 6.25 * 84 / 60 = 8.75 min/block
  - approximately (8.75 + 2.25) * 8 = 88 min, 20% longer than the original study



# Data Preprocessing



## Pipeline

Use EEGLAB default parameters, unless stated otherwise.

**DON'T CHANGE THE ORDER OF THE FOLLOWING PROCESSES.**



### Section 1

0. new a folder for each subject entitled "name+number", e.g `crq1`, and copy the .mat file of this subject generated in the experiment to this folder, then load the data into EEGLAB and select channel location (select the second option "Use MNI...")
1. re-reference to average mastoids (TP9 & TP10) and add original reference channel back as FCz
2. notch at 50Hz, filter between 0.3 ~ 50 Hz
3. bad channel (marked during the experiment **and by automatic channel rejection**) rejection, save the rejected channels' name in `chnRej.txt`
4. interpolate the rejected channels
5. epoch, -1000 ~ 4000ms locked to S1 onset (**no baseline correction**)
6. run ICA
7. save the dataset as "name+number+Epoch.set", e.g. `crq1Epoch.set`

This section can be done automatically using script `Preprocessing.m`.



### Section 2

8. ICA ocular artifact removal, save the rejected component's landscape and activation profile (shown by EEGLAB) as `cmpRej1.fig`, `cmpRej2.fig`, ... (if found)

   <img src = "cmpRejExample.jpg" style = "zoom:30%"/>

9. save the dataset

10. visual inspection, reject epochs

11. save the dataset as "name+number.set", e.g. `crq1.set`

This section needs to be done manually.



### Section 3

12. seperate the dataset according to the condition and reaction type

Probably only feasible through scripts, see the chapter below.



## Data Categorization

### Input

- 在当前目录下，有很多文件夹，命名为“姓名小写缩写+编号”，如：crq1, lyq16
- 每个文件夹里有EEGLAB预处理处理好的数据，命名为“姓名小写缩写+编号.fdt\set”，如：crq1.fdt, lyq16.set
- 每个文件夹里还包括实验时生成的试次和反应的信息，命名为“姓名小写缩写+编号.mat”，如：lyq16.mat

### Output

- 在每个被试的文件夹下生成八个mat文件，分别存储了四个条件的正确/错误试次的脑电数据，命名为“姓名小写缩写+编号+条件+反应类型.mat”，其中条件为Simple\Reversed\Transposition\Contour，反应类型为T\F，如：crq1ContourF.mat
- 文件内容：变量eegdata（nChannels * nTimepoints * nTrials single），脑电数据

### Method

- 使用`load("xxxxx.set", "-mat")`读入一个结构体`EEG`，在EEG.event.bvmknum中记录了这个数据集中所有事件的编号（范围从2到433）
- 打开eeglab并load dataset后，`EEG.data`存储了脑电数据（nChannels * nTimepoints * nTrials single）
- load dataset可以用eeglab自动生成的代码实现（手工操作一次后自动生成）



## Data Processing Pipeline in the Original Paper

### EEG Preprocessing

- re-reference to average mastoids (TP9 & TP10, rather than the original nose reference)
- artifact rejection by EEGLAB (e.g., dead channels, channel jumps, etc.)
- Filtered between 0.3 - 50 Hz
- ICA ocular artifact removal
- epoching, -1000 - 4000ms with respect to S1 onset
- visual inspection for epoch rejection
- automatic trial rejection (range of values within a trial at any electrodes > 200uV)

### Event-Related Response Analysis

- averaged seperately for SIMPLE, REVERSED correct, REVERSED incorrect and so on, with equal number of trials (random selected)
- 100ms (before onset of S1) baseline correction
- Statistics test:
  - 250ms binned (totally 8 during retention period), computing the absolute value of the mean
  - cluster-level paired t-test (by FieldTrip) on EEG topologies for each time window, multiple comparison corrected
- ROI defined by overlapping area of the main effects of REVERSED versus SIMPLE, or REVERSED correct vs incorrect, etc.

