import { round, toFixed } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, LabeledList, NumberInput, Section } from '../components';
import { BeakerContents } from './common/BeakerContents';

export const ChemPressure = props => {
  const { act, data } = useBackend(props);
  const {
    isActive,
    isBeakerLoaded,
    internalPressure,
    currentPressure,
    beakerCurrentVolume,
    beakerMaxVolume,
    beakerContents = [],
  } = data;
  return (
    <Fragment>
      <Section
        title="Pressure Gauge"
        buttons={(
          <Button
            icon={isActive ? 'power-off' : 'times'}
            selected={isActive}
            content={isActive ? 'On' : 'Off'}
            onClick={() => act('power')} />
        )}>
        <LabeledList>
          <LabeledList.Item label="Reading">
            <Box
              width="60px"
              textAlign="right">
              {isBeakerLoaded && (
                <AnimatedNumber
                  value={currentPressure}
                  format={value => toFixed(value) + ' bar'} />
              ) || '—'}
            </Box>
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