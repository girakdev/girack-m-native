import {TamaguiProvider, createTamagui} from '@tamagui/core'; // or 'tamagui'
import {config} from '@tamagui/config/v3';
import {Text} from 'tamagui';

// 通常はtamagui.config.tsファイルからエクスポートします
const tamaguiConfig = createTamagui(config);

// TypeScriptに設定に基づいてすべてを型付けさせます
type Conf = typeof tamaguiConfig;
declare module '@tamagui/core' {
  // or 'tamagui'
  interface TamaguiCustomConfig extends Conf {}
}

export default () => {
  return (
    <TamaguiProvider config={tamaguiConfig}>
      <Text>My App</Text>
    </TamaguiProvider>
  );
};
