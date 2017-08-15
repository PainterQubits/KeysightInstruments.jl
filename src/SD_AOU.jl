# SD_AOU Functions
export SD_AOU_channelWaveShape, SD_AOU_channelFrequency, SD_AOU_channelPhase
export SD_AOU_channelPhaseReset, SD_AOU_channelPhaseResetMultiple
export SD_AOU_channelAmplitude, SD_AOU_channelOffset, SD_AOU_modulationAngleConfig
export SD_AOU_modulationAmplitudeConfig, SD_AOU_modulationIQconfig
export SD_AOU_clockIOconfig, SD_AOU_waveformLoad, SD_AOU_waveformLoadArrayInt16
export SD_AOU_waveformReLoad, SD_AOU_waveformReLoadArrayInt16, SD_AOU_waveformFlush
export SD_AOU_AWGfromArray, SD_AOU_AWGfromFile, SD_AOU_AWGqueueWaveform
export SD_AOU_AWGflush, SD_AOU_AWGstart, SD_AOU_AWGstartMultiple
export SD_AOU_AWGpause, SD_AOU_AWGpauseMultiple, SD_AOU_AWGresume
export SD_AOU_AWGresumeMultiple, SD_AOU_AWGstop, SD_AOU_AWGstopMultiple
export SD_AOU_AWGreset, SD_AOU_AWGjumpNextWaveform, SD_AOU_AWGjumpNextWaveformMultiple
export SD_AOU_AWGisRunning, SD_AOU_AWGnWFplaying, SD_AOU_AWGtriggerExternalConfig
export SD_AOU_AWGtrigger, SD_AOU_AWGtriggerMultiple, SD_AOU_triggerIOconfig
export SD_AOU_triggerIOwrite, SD_AOU_triggerIOread, SD_AOU_clockSetFrequency
export SD_AOU_clockGetFrequency, SD_AOU_clockGetSyncFrequency
export SD_AOU_clockResetPhase, SD_AOU_AWGqueueConfig, SD_AOU_AWGqueueConfigRead
export SD_AOU_AWGqueueMarkerConfig, SD_AOU_AWGqueueSyncMode

## channelWaveShape
"""
This function sets the channel output waveform type.
### Output Signal Selection
- HIZ : The output signal is set to HIZ (no output signal is provided, only
available for M3202A) AOU_HIZ = -1
- No Signal : The output signal is set to 0. All other channel settings are
maintained --> AOU_OFF = 0 (default)
- Sinusoidal : Generated by the Function Generator --> AOU_SINUSOIDAL = 1
- Triangular : Generated by the Function Generator --> AOU_TRIANGULAR = 2
- Square : Generated by the Function Generator --> AOU_SQUARE = 4
- DC Voltage : The output DC voltage is set by the channel amplitude setting
--> AOU_DC = 5
- Arbitrary Waveform : Generated by the Arbitrary Waveform Generator
--> AOU_AWG = 6
- Partner Channel : Only for odd channels. It is the output of the previous
channel (to create differential signals, etc.) --> AOU_PARTNER = 8
"""
SD_AOU_channelWaveShape(moduleID::Int, nChannel::Int, waveShape::Int) =
    ccall((:SD_AOU_channelWaveShape, lib), Cint, (Cint, Cint, Cint),
        moduleID, nChannel, waveShape)
### Output Signal Selection
const AOU_HIZ               = Cint(-1)
const AOU_OFF               = Cint(0)
const AOU_SINUSOIDAL        = Cint(1)
const AOU_TRIANGULAR        = Cint(2)
const AOU_SQUARE            = Cint(4)
const AOU_DC                = Cint(5)
const AOU_AWG               = Cint(6)
const AOU_PARTNER           = Cint(8)

## channelFrequency
"""
This function sets the frequency for the periodic signals generated by the
Function Generators.
"""
SD_AOU_channelFrequency(moduleID::Int, nChannel::Int, frequency::Float64) =
    ccall((:SD_AOU_channelFrequency, lib), Cint, (Cint, Cint, Cdouble),
        moduleID, nChannel, frequency)

## channelPhase
"""
This function sets the phase for the periodic signals generated by the
Function Generators.
"""
SD_AOU_channelPhase(moduleID::Int, nChannel::Int, phase::Float64) =
    ccall((:SD_AOU_channelPhase, lib), Cint, (Cint, Cint, Cdouble),
        moduleID, nChannel, phase)

## channelPhaseReset
"""
This function resets the accumulated phase of the selected signal. This
accumulated phase is the result of the phase continuous operation of the
product.
"""
SD_AOU_channelPhaseReset(moduleID::Int, nChannel::Int) =
    ccall((:SD_AOU_channelPhaseReset, lib), Cint, (Cint, Cint),
        moduleID, nChannel)

## channelPhaseResetMultiple
"""
This function resets the accumulated phase of the selected channels
simultaneously. This accumulated phase is the result of the phase continuous
operation of the product.
"""
SD_AOU_channelPhaseResetMultiple(moduleID::Int, channelMask::Int) =
    ccall((:SD_AOU_channelPhaseResetMultiple, lib), Cint, (Cint, Cint),
        moduleID, channelMask)

## channelAmplitude
"""
This function sets the amplitude of a channel.
"""
SD_AOU_channelAmplitude(moduleID::Int, nChannel::Int, amplitude::Float64) =
    ccall((:SD_AOU_channelAmplitude, lib), Cint, (Cint, Cint, Cdouble),
        moduleID, nChannel, amplitude)

## channelOffset
"""
This function sets the DC offset of a channel.
"""
SD_AOU_channelOffset(moduleID::Int, nChannel::Int, offset::Float64) =
    ccall((:SD_AOU_channelOffset, lib), Cint, (Cint, Cint, Cdouble),
        moduleID, nChannel, offset)

## modulationAngleConfig
"""
This function configures the modulation in frequency/phase for the selected
channel.
"""
SD_AOU_modulationAngleConfig(moduleID::Int, nChannel::Int, modulationType::Int,
    deviationGain::Int) =
    ccall((:SD_AOU_modulationAngleConfig, lib), Cint, (Cint, Cint, Cint, Cint),
        moduleID, nChannel, modulationType, deviationGain)

## modulationAmplitudeConfig
"""
This function configures the modulation in amplitude/offset for the selected
channel.
"""
SD_AOU_modulationAmplitudeConfig(moduleID::Int, nChannel::Int,
    modulationType::Int, deviationGain::Int) =
    ccall((:SD_AOU_modulationAmplitudeConfig, lib), Cint, (Cint, Cint, Cint,
        Cint), moduleID, nChannel, modulationType, deviationGain)

## modulationIQconfig
"""
This function sets the IQ modulation for the selected channel.
"""
SD_AOU_modulationIQconfig(moduleID::Int, nChannel::Int, enable::Int) =
    ccall((:SD_AOU_modulationIQconfig, lib), Cint, (Cint, Cint, Cint),
        moduleID, nChannel, enable)

## clockIOconfig
"""
This function configures the operation of the clock output connector.
"""
SD_AOU_clockIOconfig(moduleID::Int, clockConfig::Int) =
    ccall((:SD_AOU_clockIOconfig, lib), Cint, (Cint, Cint), moduleID,
        clockIOconfig)

## waveformLoad
"""
This function loads the specified waveform into the module onboard RAM.
Waveforms must be created first with the SD-Wave class.
"""
SD_AOU_waveformLoad(moduleID::Int, waveformID::Int, waveformNumber::Int,
    paddingMode::Int) =
    ccall((:SD_AOU_waveformLoad, lib), Cint, (Cint, Cint, Cint, Cint),
        moduleID, waveformID, waveformNumber, paddingMode)

function SD_AOU_waveformLoadArrayInt16(moduleID::Int, waveformType::Int,
    waveformDataRaw::Vector{Int16}, waveformNumber::Int, paddingMode::Int)
    waveformPoints = length(waveformDataRaw) # Not sure..
    val = ccall((:SD_AOU_waveformLoadArrayInt16, lib), Cint,
        (Cint, Cint, Cint, Ref{Cshort}, Cint, Cint), moduleID, waveformType,
        waveformPoints, waveformDataRaw, waveformNumber, paddingMode)
    return val
end

## waveformReLoad
"""
This function replaces a waveform located in the module onboard RAM. The size of
the new waveform must be smaller than or equal to the existing waveform.
"""
SD_AOU_waveformReLoad(moduleID::Int, waveformID::Int, waveformNumber::Int,
    paddingMode::Int) =
    ccall((:SD_AOU_waveformReLoad, lib), Cint, (Cint, Cint, Cint, Cint),
        moduleID, waveformID, waveformNumber, paddingMode)

function SD_AOU_waveformReLoadArrayInt16(moduleID::Int, waveformType::Int,
    waveformDataRaw::Vector{Int16}, waveformNumber::Int, paddingMode::Int)
    waveformPoints = length(waveformDataRaw)
    val = ccall((:SD_AOU_waveformReLoadArrayInt16, lib), Cint,
        (Cint, Cint, Cint, Ref{Cshort}, Cint, Cint), moduleID, waveformType,
        waveformPoints, waveformDataRaw, waveformNumber, paddingMode)
    return val
end

## waveformFlush
"""
This function deletes all the waveforms from the module onboard RAM and flushes
all the AWG queues.
"""
SD_AOU_waveformFlush(moduleID::Int) =
    ccall((:SD_AOU_waveformFlush, lib), Cint, (Cint,), moduleID)

## AWG
"""
This function provides a one-step method to load, queue and start a single
waveform in one of the module AWGs. The waveform can be loaded from an array of
points in memory or from a file.
### AWG Trigger Mode
- Auto : The waveform is launched automatically after function AWGstart, or
when the previous waveform in the queue finishes
"""
function SD_AOU_AWGfromArray(moduleID::Int, nAWG::Int, triggerMode::Int,
    startDelay::Int, cycles::Int, prescaler::Int, waveformType::Int,
    waveformDataA::Vector{Float64}, waveformDataB::Vector{Float64}=0)
    waveformPoints = length(waveformDataA)
    val = ccall((:SD_AOU_AWGfromArray, lib), Cint, (Cint, Cint, Cint, Cint,
        Cint, Cint, Cint, Cint, Ref{Cdouble}, Ref{Cdouble}), moduleID, nAWG,
        triggerMode, startDelay, cycles, prescaler, waveformType,
        waveformPoints, waveformDataA, waveformDataB)
    return val
end

SD_AOU_AWGfromFile(moduleID::Int, nAWG::Int, waveformFile::String,
    triggerMode::Int, startDelay::Int, cycles::Int, prescaler::Int) =
    ccall((:SD_AOU_AWGfromFile, lib), Cint, (Cint, Cint, Cstring, Cint, Cint,
        Cint, Cint), moduleID, nAWG, waveformFile, triggerMode, startDelay,
        cycles, prescaler)
    # not sure if waveformFile is a pointer to the file or just a string of filename

## AWGqueueWaveform
"""
This function queues the specified waveform in one of the AWGs of the module.
The waveform must be already loaded in the module onboard RAM.
"""
SD_AOU_AWGqueueWaveform(moduleID::Int, nAWG::Int, waveformNumber::Int,
    triggerMode::Int, startDelay::Int, cycles::Int, prescaler::Int) =
    ccall((:SD_AOU_AWGqueueWaveform, lib), Cint, (Cint, Cint, Cint, Cint, Cint,
        Cint, Cint), moduleID, nAWG, waveformNumber, triggerMode, startDelay,
        cycles, prescaler)

## AWGflush
"""
This function empties the queue of the selected AWGs. Waveforms are not removed
from the module onboard RAM.
"""
SD_AOU_AWGflush(moduleID::Int, nAWG::Int) =
    ccall((:SD_AOU_AWGflush, lib), Cint, (Cint, Cint), moduleID, nAWG)

## AWGstart
"""
This function starts he selected AWG from the beginning of its queue. The
generation will start immediately or when a trigger is received, depending on
the trigger selection of the first waveform in the queue and provided that at
least one waveform is queued in the AWG.
"""
SD_AOU_AWGstart(moduleID::Int, nAWG::Int) =
    ccall((:SD_AOU_AWGstart, lib), Cint, (Cint, Cint), moduleID, nAWG)

## AWGstartMultiple
"""
This function starts the selected AWGs from the beginning of their queues. The
generation will start immediately or when a trigger is received, depending on
the trigger selection of the first waveform in their queues and provided that at
least one waveform is queued in these AWGs (functions AWGqueueWaveform, or AWG).
"""
SD_AOU_AWGstartMultiple(moduleID::Int, AWGmask::Int) =
    ccall((:SD_AOU_AWGstartMultiple, lib), Cint, (Cint, Cint),
        moduleID, AWGmask)

## AWGpause
"""
This function pauses the selected AWG, leaving the last waveform point at the
output, and ignoring all incoming triggers. The waveform generation can be
resumed calling AWGresume.
"""
SD_AOU_AWGpause(moduleID::Int, nAWG::Int) =
    ccall((:SD_AOU_AWGpause, lib), Cint, (Cint, Cint), moduleID, nAWG)

## AWGpauseMultiple
"""
This function pauses the selected AWGs, leaving the last waveform point at the
output, and ignoring all incoming triggers. The waveform generation can be
resumed calling AWGresume.
"""
SD_AOU_AWGpauseMultiple(moduleID::Int, AWGmask::Int) =
    ccall((:SD_AOU_AWGpauseMultiple, lib), Cint, (Cint, Cint), moduleID,
        AWGmask)

## AWGresume
"""
The function resumes the operation of the selected AWG from the current
position of the queue.
"""
SD_AOU_AWGresume(moduleID::Int, nAWG::Int) =
    ccall((:SD_AOU_AWGresume, lib), Cint, (Cint, Cint), moduleID, nAWG)

## AWGresumeMultiple
"""
This function resumes the operation of the selected AWGs from the current
position of their respective queues.
"""
SD_AOU_AWGresumeMultiple(moduleID::Int, AWGmask::Int) =
    ccall((:SD_AOU_AWGresumeMultiple, lib), Cint, (Cint, Cint), moduleID,
        AWGmask)

## AWGstop
"""
This function stops the selected AWG, setting the output to zero and resetting
the AWG queue to its initial position. All following incoming triggers are
ignored.
"""
SD_AOU_AWGstop(moduleID::Int, nAWG::Int) =
    ccall((:SD_AOU_AWGstop, lib), Cint, (Cint, Cint), moduleID, nAWG)

## AWGstopMultiple
"""
This function stops the selected AWGs, setting their outputs to zero and
resetting their respective queues to the initial positions. All following
incoming triggers are ignored.
"""
SD_AOU_AWGstopMultiple(moduleID::Int, AWGmask::Int) =
    ccall((:SD_AOU_AWGstopMultiple, lib), Cint, (Cint, Cint), moduleID, AWGmask)

## AWGreset
"""
This function resets the selected AWG to its initial position.
"""
SD_AOU_AWGreset(moduleID::Int, nAWG::Int) =
    ccall((:SD_AOU_AWGreset, lib), Cint, (Cint, Cint), moduleID, nAWG)

## AWGjumpNextWaveform
"""
This function forces a jump to the next waveform in the AWG queue. The jump is
executed once the current waveform has finished a complete cycle.
"""
SD_AOU_AWGjumpNextWaveform(moduleID::Int, nAWG::Int) =
    ccall((:SD_AOU_AWGjumpNextWaveform, lib), Cint, (Cint, Cint), moduleID,
        nAWG)

## AWGjumpNextWaveformMultiple
"""
This function forces a jump to the next waveform in the queue of several AWGs.
The jumps are executed once the current waveforms have finished a complete
cycle.
"""
SD_AOU_AWGjumpNextWaveformMultiple(moduleID::Int, AWGmask::Int) =
    ccall((:SD_AOU_AWGjumpNextWaveformMultiple, lib), Cint, (Cint, Cint),
        moduleID, AWGmask)

## AWGisRunning
"""
This function returns if the AWG is running or stopped.
"""
SD_AOU_AWGisRunning(moduleID::Int, nAWG::Int) =
    ccall((:SD_AOU_AWGisRunning, lib), Cint, (Cint, Cint), moduleID, nAWG)

## AWGnWFplaying
"""
This function returns the waveformNumber of the waveform which is currently
being generated.
"""
SD_AOU_AWGnWFplaying(moduleID::Int, nAWG::Int) =
    ccall((:SD_AOU_AWGnWFplaying, lib), Cint, (Cint, Cint), moduleID, nAWG)

## AWGtriggerExternalConfig
"""
This function configures the external triggers for the selected AWG. The
external trigger is used in case the waveform is queued with the external
trigger mode option (function AWGqueueWaveform).
"""
SD_AOU_AWGtriggerExternalConfig(moduleID::Int, nAWG::Int, externalSource::Int,
    triggerBehavior::Int) =
    ccall((:SD_AOU_AWGtriggerExternalConfig, lib), Cint, (Cint, Cint, Cint,
        Cint), moduleID, nAWG, externalSource, triggerBehavior)

## AWGtrigger
"""
This function triggers the selected AWG. The waveform waiting in the current
position of the queue is launched provided it is configured with VI/HVI Trigger.
"""
SD_AOU_AWGtrigger(moduleID::Int, nAWG::Int) =
    ccall((:SD_AOU_AWGtrigger, lib), Cint, (Cint, Cint), moduleID, nAWG)

## AWGtriggerMultiple
"""
This function triggers the selected AWGs. The waveform waiting in the current
position of the queue is launched provided it is configured with VI/HVI Trigger.
"""
SD_AOU_AWGtriggerMultiple(moduleID::Int, AWGmask::Int) =
    ccall((:SD_AOU_AWGtriggerMultiple, lib), Cint, (Cint, Cint), moduleID,
        AWGmask)

## triggerIOconfig
"""
This function configures the trigger connector/line direction and
synchronization/sampling method
"""
SD_AOU_triggerIOconfig(moduleID::Int, direction::Int, syncMode::Int) =
    ccall((:SD_AOU_triggerIOconfig, lib), Cint, (Cint, Cint, Cint), moduleID,
        direction, syncMode)

## triggerIOwrite
"""
This function sets the trigger output. The trigger must be configured as output
using function triggerIOconfig.
"""
SD_AOU_triggerIOwrite(moduleID::Int, value::Int) =
    ccall((:SD_AOU_triggerIOwrite, lib), Cint, (Cint, Cint), moduleID, value)

## triggerIOread
"""
This function reads the trigger input.
"""
SD_AOU_triggerIOread(moduleID::Int) =
    ccall((:SD_AOU_triggerIOread, lib), Cint, (Cint,), moduleID)

## clockSetFrequency
"""
This function sets the module clock frequency.
"""
SD_AOU_clockSetFrequency(moduleID::Int, frequency::Float64, mode::Int) =
    ccall((:SD_AOU_clockSetFrequency, lib), Cdouble, (Cint, Cdouble, Cint),
        moduleID, frequency, mode)

## clockGetFrequency
"""
This function returns the real hardware clock frequency. It may differ from the
frequency set with the function clockSetFrequency, due to the hardware
frequency resolution.
"""
SD_AOU_clockGetFrequency(moduleID::Int) =
    ccall((:SD_AOU_clockGetFrequency, lib), Cdouble, (Cint,), moduleID)

## clockGetSyncFrequency
"""
This function returns the frequency of Clock System
"""
SD_AOU_clockGetSyncFrequency(moduleID::Int) =
    ccall((:SD_AOU_clockGetSyncFrequency, lib), Cint, (Cint,), moduleID)

## clockResetPhase
SD_AOU_clockResetPhase(moduleID::Int, triggerBehavior::Int, PXItrigger::Int,
    skew::Float64) =
    ccall((:SD_AOU_clockResetPhase, lib), Cint, (Cint, Cint, Cint, Cdouble),
        moduleID, triggerBehavior, PXItrigger, skew)

## AWGqueueConfig
"""
This function configures the cyclic mode of the queue. All waveforms must be
already queued in one of the AWGs of the module.
"""
SD_AOU_AWGqueueConfig(moduleID::Int, nAWG::Int, mode::Int) =
    ccall((:SD_AOU_AWGqueueConfig, lib), Cint, (Cint, Cint, Cint), moduleID,
        nAWG, mode)

## AWGqueueConfigRead
"""
This function reads the value of a cyclic mode of the queue. All waveforms must
be already queued in one of the AWGs of the module.
"""
SD_AOU_AWGqueueConfigRead(moduleID::Int, nAWG::Int) =
    ccall((:SD_AOU_AWGqueueConfigRead, lib), Cint, (Cint, Cint), moduleID, nAWG)

## AWGqueueMarkerConfig
"""
This function configures the Marker generation for each AWG. All waveforms must
be already queued in one of the AWGs of the module.
"""
SD_AOU_AWGqueueMarkerConfig(moduleID::Int, nAWG::Int, markerMode::Int,
    trgPXImask::Int, trgIOmask::Int, value::Int, syncMode::Int, length::Int,
    delay::Int) =
    ccall((:SD_AOU_AWGqueueMarkerConfig, lib), Cint,
        (Cint, Cint, Cint, Cint, Cint, Cint, Cint, Cint, Cint),
        moduleID, nAWG, markerMode, trgPXImask, trgIOmask, value, syncMode,
        length, delay)

## AWGqueueSyncMode
"""
This function configures the sync mode of the queue. All waveforms must be
already queued in one of the AWGs of the module.
"""
SD_AOU_AWGqueueSyncMode(moduleID::Int, nAWG::Int, syncMode::Int) =
    ccall((:SD_AOU_AWGqueueSyncMode, lib), Cint, (Cint, Cint, Cint),
        moduleID, nAWG, syncMode)
