import { round, toFixed } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, LabeledList, NumberInput, ProgressBar, Section } from '../components';
import { BeakerContents } from './common/BeakerContents';

export const ChemRadioactive = props => {
  const { act, data } = useBackend(props);
  const {
    targetRadioactivity,
    isActive,
    isBeakerLoaded,
    materialAmount,
    currentRadioactivity,
    beakerCurrentVolume,
    beakerMaxVolume,
    beakerContents = [],
  } = data;
  return (
    <Fragment>
      <Section
        title="Particle Detector"
        buttons={(
          <Button
            icon={isActive ? 'power-off' : 'times'}
            selected={isActive}
            content={isActive ? 'On' : 'Off'}
            onClick={() => act('power')} />
        )}>
        <LabeledList>
          <LabeledList.Item label="Target">
            <NumberInput
              width="65px"
              unit="Bq"
              step={2}
              stepPixelSize={1}
              value={round(targetRadioactivity)}
              minValue={0}
              maxValue={20}
              onDrag={(e, value) => act('irradiate', {
                target: value,
              })} />
          </LabeledList.Item>
          <LabeledList.Item label="Reading">
            <Box
              width="60px"
              textAlign="right">
              {isBeakerLoaded && (
                <AnimatedNumber
                  value={currentRadioactivity}
                  format={value => toFixed(value) + ' Bq'} />
              ) || '—'}
            </Box>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Internal reactor">
        <LabeledList>
          <LabeledList.Item label="Uranium amount">
            <ProgressBar
              value={materialAmount / data.material_max}>
              <AnimatedNumber value={materialAmount} />
            </ProgressBar>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Beaker"
        buttons={!!isBeakerLoaded && (
          <Fragment>
            <Box inline color="label" mr={2}>
              {beakerCurrentVolume} / {beakerMaxVolume} units
            </Box>
            <Button
              icon="eject"
              content="Eject"
              onClick={() => act('eject')} />
          </Fragment>
        )}>
        <BeakerContents
          beakerLoaded={isBeakerLoaded}
          beakerContents={beakerContents} />
      </Section>
    </Fragment>
  );
};
