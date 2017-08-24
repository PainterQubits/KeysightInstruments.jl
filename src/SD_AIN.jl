# SD_AIN Functions for Keysight M31XXA/M33XXA Digitizers
export SD_AIN_channelInputConfig, SD_AIN_channelPrescalerConfig
export SD_AIN_channelTriggerConfig, SD_AIN_DAQconfig, SD_AIN_DAQdigitalTriggerConfig
export SD_AIN_DAQanalogTriggerConfig, SD_AIN_DAQread, SD_AIN_DAQstart
export SD_AIN_DAQstartMultiple, SD_AIN_DAQstop, SD_AIN_DAQstopMultiple
export SD_AIN_DAQpause, SD_AIN_DAQpauseMultiple, SD_AIN_DAQresume
export SD_AIN_DAQresumeMultiple, SD_AIN_DAQflush, SD_AIN_DAQflushMultiple
export SD_AIN_DAQtrigger, SD_AIN_DAQtriggerMultiple, SD_AIN_DAQcounterRead
export SD_AIN_triggerIOconfig, SD_AIN_triggerIOwrite, SD_AIN_triggerIOread
export SD_AIN_clockSetFrequency, SD_AIN_clockGetFrequency, SD_AIN_clockGetSyncFrequency
export SD_AIN_clockResetPhase, SD_AIN_DAQbufferPoolConfig, SD_AIN_DAQbufferAdd
export SD_AIN_DAQbufferGet, SD_AIN_DAQbufferRelease, SD_AIN_DAQbufferRemove
export SD_AIN_FFT

## channelInputConfig
"""
This function configures the input full scale, impedance and coupling as
applicable according to the product.
### Input Impedance
- High Impedance : Input impedance is high --> AIN_IMPEDANCE_HZ = 0
- 50Ω : Input impedance is 50Ω  --> AIN_IMPEDANCE_50 = 1
### Input Coupling
- DC : DC coupling --> AIN_COUPLING_DC = 0
- AC : AC coupling --> AIN_COUPLING_AC = 1
"""
SD_AIN_channelInputConfig(moduleID::Integer, nChannel::Integer, fullScale::Float64,
	coupling::Integer) =
	ccall((:SD_AIN_channelInputConfig, lib), Cint, (Cint, Cint, Cdouble, Cint),
		moduleID, nChannel, fullScale, coupling)

## channelPrescalerConfig
"""
This function configures the input prescaler.
"""
SD_AIN_channelPrescalerConfig(moduleID::Integer, nChannel::Integer, prescaler::Integer) =
	ccall((:SD_AIN_channelPrescalerConfig, lib), Cint, (Cint, Cint, Cint),
		moduleID, nChannel, prescaler)

## channelTriggerConfig
"""
This function configures the analog trigger block for each channel.
### Analog Trigger Mode
- Rising Edge : Trigger is generated when the input signal is rising and crosses
the threshold --> AIN_RISING_EDGE = 0
- Falling Edge : Trigger is generated when the input signal is falling and
crosses the threshold --> AIN_FALLING_EDGE = 1
- Both Edges : Trigger is generated when the input signal crosses the threshold,
no matter if it is rising or falling --> AIN_BOTH_EDGES = 3
"""
SD_AIN_channelTriggerConfig(moduleID::Integer, nChannel::Integer,
	analogTriggerMode::Integer, threshold::Float64) =
	ccall((:SD_AIN_channelTriggerConfig, lib), Cint, (Cint, Cint, Cint,
		Cdouble), moduleID, nChannel, analogTriggerMode, threshold)

## DAQconfig
"""
This function configures the acquisition of words in two possible reading modes:
- Blocking: Using the function to read the words. DAQread is a blocking function
that is released when the amount of words specified in DAQpoints is acquired or
when timeout elapses. This mode is enabled when a callback function is not
specified (it is set to null).
- Non-blocking: The user specifies a callback function which is called whenever
the DAQeventDataReady event is signaled or when timeout elapses. In the latter
condition, there may be words available, but less than the amount specified in
DAQpoints.
### DAQ Trigger Mode
- Auto (Immediate) : The acquisition starts automatically after a call to
function DAQstart --> AUTOTRIG = 0
- Software / HVI : Software trigger. The acquisition is triggered by the
function DAQtrigger, provided that the DAQ is running. DAQtrigger can be
executed from the user application (VI) or from an HVI --> SWHVITRIG = 1
- Hardware Digital Trigger : Hardware trigger. The DAQ waits for an external
digital trigger --> HWDIGTRIG = 2
- Hardware Analog Trigger : Hardware trigger. The DAQ waits for an external
analog trigger (only products with analog inputs) --> HWANATRIG = 3
"""
SD_AIN_DAQconfig(moduleID::Integer, nDAQ::Integer, DAQpointsPerCycle::Integer, cycles::Integer,
	triggerDelay::Integer, triggerMode::Integer) =
	ccall((:SD_AIN_DAQconfig, lib), Cint, (Cint, Cint, Cint, Cint, Cint, Cint),
		moduleID, nDAQ, DAQpointsPerCycle, cycles, triggerDelay, triggerMode)

## DAQdigitalTriggerConfig
"""
This function configures the digital hardware triggers for the selected DAQ.
### DAQ Hardware Digital Trigger Source
- External I/O Trigger : The DAQ trigger is a TRG connector/line of the product.
PXI form factor only: this trigger can be synchronized to CLK10
--> TRIG_EXTERNAL = 0
- PXI Trigger : PXI form factor only. The DAQ trigger is a PXI trigger line
and it is synchronized to CLK10 --> TRIG_PXI = 1
### DAQ Hardware Digital Trigger Behavior
- Active High : Trigger is active when it is at level high --> TRIG_HIGH = 1
- Active Low : Trigger is active when it is at level low --> TRIG_LOW = 2
- Rising Edge : Trigger is active on the rising edge --> TRIG_RISE = 3
- Falling Edge : Trigger is active on the falling edge --> TRIG_FALL = 4
"""
SD_AIN_DAQdigitalTriggerConfig(moduleID::Integer, nDAQ::Integer, triggerSource::Integer,
	triggerNumber::Integer, triggerBehavior::Integer) =
	ccall((:SD_AIN_DAQdigitalTriggerConfig, lib), Cint, (Cint, Cint, Cint, Cint,
		Cint), moduleID, nDAQ, triggerSource, triggerNumber, triggerBehavior)

## DAQanalogTriggerConfig
"""
This function configures the analog hardware trigger for the selected DAQ.
"""
SD_AIN_DAQanalogTriggerConfig(moduleID::Integer, nDAQ::Integer, triggerNumber::Integer) =
	ccall((:SD_AIN_DAQanalogTriggerConfig, lib), Cint, (Cint, Cint, Cint),
		moduleID, nDAQ, triggerNumber)

## DAQread
"""
This function reads the words acquired with the selected DAQ. It can be used
only after calling the function DAQconfig and when a callback function is not
configured. DAQread is a blocking function released when the configured amount
of words is acquired, or when the configured timeout elapses (if timeout is set
to ”0” , then DAQread waits until DAQpoints are acquired). In the timeout
elapses, there may be words available, but less than the configured amount.
"""
function SD_AIN_DAQread(moduleID::Integer, nDAQ::Integer, DAQpoints::Integer, timeout::Integer)
	DAQdata = Vector{Cshort}(DAQpoints) 	# Create an array to retrieve data
	# DAQdata contains DAQpoints words. Its size is DAQpoints × 2bytes/word.
 	val = ccall((:SD_AIN_DAQread, lib), Cint, (Cint, Cint, Ref{Cshort}, Cint,
		Cint), moduleID, nDAQ, DAQdata, DAQpoints, timeout)
	if val >= 0
		return DAQdata
	else
		return val
	end
end

## DAQstart
"""
This function starts acquisition on the selected DAQ. Acquisition will start
when a trigger is received.
"""
SD_AIN_DAQstart(moduleID::Integer, nDAQ::Integer) =
	ccall((:SD_AIN_DAQstart, lib), Cint, (Cint, Cint), moduleID, nDAQ)

## DAQstartMultiple
"""
This function starts acquisition on the selected DAQs. Acquisition will start
when a trigger is received.
"""
SD_AIN_DAQstartMultiple(moduleID::Integer, DAQmask::Integer) =
	ccall((:SD_AIN_DAQstartMultiple, lib), Cint, (Cint, Cint),
		moduleID, DAQmask)

## DAQstop
"""
This function stops the words acquisition on the selected DAQ.
"""
SD_AIN_DAQstop(moduleID::Integer, nDAQ::Integer) =
	ccall((:SD_AIN_DAQstop, lib), Cint, (Cint, Cint), moduleID, nDAQ)

## DAQstopMultiple
"""
This function pauses the words acquisition on the selected DAQs.
"""
SD_AIN_DAQstopMultiple(moduleID::Integer, DAQmask::Integer) =
	ccall((:SD_AIN_DAQstopMultiple, lib), Cint, (Cint, Cint),
		moduleID, DAQmask)

## DAQpause
"""
This function pauses the words acquisition on the selected DAQ. Acquisition can
be resumed using DAQresume.
"""
SD_AIN_DAQpause(moduleID::Integer, nDAQ::Integer) =
    ccall((:SD_AIN_DAQpause, lib), Cint, (Cint, Cint), moduleID, nDAQ)

## DAQpauseMultiple
"""
This function pauses the words acquisition on the selected DAQs. Acquisition can
be resumed using DAQresume.
"""
SD_AIN_DAQpauseMultiple(moduleID::Integer, DAQmask::Integer) =
    ccall((:SD_AIN_DAQpauseMultiple, lib), Cint, (Cint, Cint),
        moduleID, DAQmask)

## DAQresume
"""
This function resumes acquisition on the selected DAQ.
"""
SD_AIN_DAQresume(moduleID::Integer, nDAQ::Integer) =
	ccall((:SD_AIN_DAQresume, lib), Cint, (Cint, Cint), moduleID, nDAQ)

## DAQresumeMultiple
"""
This function resumes acquisition on the selected DAQs.
"""
SD_AIN_DAQresumeMultiple(moduleID::Integer, DAQmask::Integer) =
    ccall((:SD_AIN_DAQresumeMultiple, lib), Cint, (Cint, Cint),
        moduleID, DAQmask)

## DAQflush
"""
This function flushes the acquisition buffers and resets the acquisition counter
included in a Data Acquisition block.
"""
SD_AIN_DAQflush(moduleID::Integer, nDAQ::Integer) =
    ccall((:SD_AIN_DAQflush, lib), Cint, (Cint, Cint), moduleID, nDAQ)

## DAQflushMultiple
"""
This function flushes the acquisition buffers and resets the acquisition counter
included in a Data Acquisition block.
"""
SD_AIN_DAQflushMultiple(moduleID::Integer, DAQmask::Integer) =
    ccall((:SD_AIN_DAQflushMultiple, lib), Cint, (Cint, Cint),
        moduleID, DAQmask)

## DAQtrigger
"""
This function triggers the acquisition of words in the selected DAQs provided
that they are configured for VI/HVI Trigger.
"""
SD_AIN_DAQtrigger(moduleID::Integer, nDAQ::Integer) =
    ccall((:SD_AIN_DAQtrigger, lib), Cint, (Cint, Cint), moduleID, nDAQ)

## DAQtriggerMultiple
"""
This function triggers the acquisition of words in the selected DAQs provided
that they are configured for VI/HVI Trigger.
"""
SD_AIN_DAQtriggerMultiple(moduleID::Integer, DAQmask::Integer) =
    ccall((:SD_AIN_DAQtriggerMultiple, lib), Cint, (Cint, Cint),
        moduleID, DAQmask)

## DAQcounterRead
"""
This function reads the number of words acquired by the selected DAQ since the
last call to DAQflush or DAQ.
"""
SD_AIN_DAQcounterRead(moduleID::Integer, DAQ::Integer) =
    ccall((:SD_AIN_DAQcounterRead, lib), Cint, (Cint, Cint), moduleID, DAQ)

## triggerIOconfig
"""
This function configures the trigger connector/line direction and
synchronization/sampling method.
### Trigger I/O Options
- Trigger Output (readable) : TRG operates as a general purpose digital output
signal, which can be written by the user software --> AOU_TRIG_OUT = 0
- Trigger Input : TRG operates as a trigger input, or as general purpose digital
input signal, which can be read by the user software --> AOU_TRIG_IN = 1
### Trigger Synchronization/Sampling Options
- Non-synchronized mode : The trigger is sampled with an internal 100 MHz clock
--> SYNC_NONE = 0
- Synchronized mode : (PXI form factor only) The trigger is sampled using CLK10
--> SYNC_CLK_0 = 1
"""
SD_AIN_triggerIOconfig(moduleID::Integer, direction::Integer, syncMode::Integer) =
    ccall((:SD_AIN_triggerIOconfig, lib), Cint, (Cint, Cint, Cint),
        moduleID, direction, syncMode)

## triggerIOwrite
"""
This function sets the trigger output. The trigger must be configured as output
using function triggerIOconfig and I/O Triggers.
"""
SD_AIN_triggerIOwrite(moduleID::Integer, value::Integer) =
    ccall((:SD_AIN_triggerIOwrite, lib), Cint, (Cint, Cint), moduleID, value)

## triggerIOread
"""
This function reads the trigger input.
"""
SD_AIN_triggerIOread(moduleID::Integer) =
    ccall((:SD_AIN_triggerIOread, lib), Cint, (Cint,), moduleID)

## clockSetFrequency
"""
This function sets the module clock frequency, see FlexCLK Technology (models
with variable sampling rate).
### CLK Set Frequency Mode
- Low Jitter Mode : The clock system is set to achieve the lowest jitter,
sacrificing tuning speed --> CLK_LOW_JITTER = 0
- Fast Tuning Mode : The clock system is set to achieve the lowest tuning time,
sacrificing jitter performance --> CLK_FAST_TUNE = 1
"""
SD_AIN_clockSetFrequency(moduleID::Integer, frequency::Float64, mode::Integer) =
    ccall((:SD_AIN_clockSetFrequency, lib), Cdouble, (Cint, Cdouble, Cint),
        moduleID, frequency, mode)

## clockGetFrequency
"""
This function returns the real hardware clock frequency. It may differ from the
frequency set with the function clockSetFrequency, due to the hardware
frequency resolution.
"""
SD_AIN_clockGetFrequency(moduleID::Integer) =
	ccall((:SD_AIN_clockGetFrequency, lib), Cdouble, (Cint,), moduleID)

## clockGetSyncFrequency
"""
This function returns the frequency of Clock System.
"""
SD_AIN_clockGetSyncFrequency(moduleID::Integer) =
	ccall((:SD_AIN_clockGetSyncFrequency, lib), Cint, (Cint,), moduleID)

## clockResetPhase
"""
This function sets the module in a sync state, waiting for the first trigger to
reset the phase of the internal clocks CLKsync and CLKsys.
"""
SD_AIN_clockResetPhase(moduleID::Integer, triggerBehavior::Integer, PXItrigger::Integer,
	skew::Float64) =
	ccall((:SD_AIN_clockResetPhase, lib), Cint, (Cint, Cint, Cint, Cdouble),
		moduleID, triggerBehavior, PXItrigger, skew)

## DAQbufferPoolConfig: TODO
#"""
#This function configures buffer pool that will be filled with the data of the
#channel to be transferred to PC.
#"""
#function SD_AIN_DAQbufferPoolConfig(moduleID::Integer, nDAQ::Integer, nPoints::Integer,
#	timeOut::Integer)
#	dataBuffer = Vector{Cshort}(nPoints)
#	val = ccall((:SD_AIN_DAQbufferPoolConfig, lib), Cint, (Cint, Cint, Ref{Cshort}, Cint, Cint, , Void))
# int SD_AIN_DAQbufferPoolConfig(int moduleID, int nDAQ,short* dataBuffer, int nPoints, int timeOut, callbackEventPtr callbackFunction,void *callbackUserObj);

## DAQbufferAdd
"""
Adds an additional buffer to the channel’s previously configured pool.
"""
function SD_AIN_DAQbufferAdd(moduleID::Integer, nDAQ::Integer,
	dataBuffer::Vector{Int16}, nPoints::Integer)
	nPoints = length(dataBuffer)
	val = ccall((:SD_AIN_DAQbufferAdd, lib), Cint, (Cint, Cint, Ref{Cshort}, Cint),
		moduleID, nDAQ, dataBuffer, nPoints)
	return val
end

## DAQbufferGet: TODO
#"""
#Gets a filled buffer from the channel buffer pool. User has to call DAQbufferAdd
#with this buffer to tell the pool that the buffer can be used again.
#"""
#SD_AIN_DAQbufferGet(moduleID::Integer, nDAQ::Integer) =
#    short* SD_AIN_DAQbufferGet(int moduleID, int nDAQ, int &readPointsOut, int &errorOut);

## DAQbufferPoolRelease
"""
Releases the channel buffer pool and its resources. After this call, user has to
call DAQbufferRemove consecutively to get all buffers back and release them.
"""
SD_AIN_DAQbufferRelease(moduleID::Integer, nDAQ::Integer) =
	ccall((:SD_AIN_DAQbufferRelease, lib), Cint, (Cint, Cint), moduleID, nDAQ)

## DAQbufferPoolRemove
"""
Ask for a buffer to be removed from the channel buffer pool. If NULL pointer is
returned, no more buffers remains in buffer pool. Returned buffer is a
previously added buffer from user and user has to release/delete it.
"""
function SD_AIN_DAQbufferRemove(moduleID::Integer, nDAQ::Integer)
	ptr = ccall((:SD_AIN_DAQbufferRemove, lib), Ptr{Cshort}, (Cint, Cint),
		moduleID, nDAQ)
	return unsafe_load(ptr)
end

## FFT
"""
Calculates the FFT of data captured by DAQread for the selected channel.
### Window types used in FFT function
- Rectangular : Simplest B-spine window --> WINDOW_RECTANGULAR = 0 (default)
- Bartlett : Hybrid window --> WINDOW_BARTLETT = 1
- Hanning : Side-lobes roll off about 18 dB per octave --> WINDOW_HANNING = 2
- Hamming : Optimized to minimize the maximum nearest side lobe
--> WINDOW_HAMMING = 3
- Blackman : Higher-order generalized cosine windows for applications that
require windowing by the convolution in the frequency-domain
--> WINDOW_BLACKMAN = 4
- Kaiser : Adjustable window maximizing energy concentration in the main lobe
--> WINDOW_KAISER = 5
- Gauss : Adjustable window (can be used for quadratic interpolation in
frequency estimation) --> WINDOW_GAUSS = 6
"""
function SD_AIN_FFT(moduleID::Integer, channel::Integer, data::Array{Int16}, dB::Bool,
    windowType::Integer)
	dataSize = length(data)
	resultSize = dataSize
	resultMag = Vector{Cdouble}(resultSize)
	resultPhase = Vector{Cdouble}(resultSize)
	val = ccall((:SD_AIN_FFT, lib), Cint, (Cint, Cint, Ref{Cshort}, Cint,
		Ref{Cdouble}, Cint, Ref{Cdouble}, Bool, Cint), moduleID, channel, data,
		dataSize, resultMag, resultSize, resultPhase, dB, windowType)
	if val >= 0
		return resultMag, resultPhase
	else
		return val
	end
end
