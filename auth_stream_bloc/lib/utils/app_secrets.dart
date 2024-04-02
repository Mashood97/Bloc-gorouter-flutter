import 'package:envied/envied.dart';

part 'app_secrets.g.dart';

@Envied(path: '.env')
abstract class AppSecrets {
  @EnviedField(
    varName: 'supabase_url',
    obfuscate: true,
  )
  static final String supabaseUrl = _AppSecrets.supabaseUrl;

  @EnviedField(
    varName: 'supasebase_key',
    obfuscate: true,
  )
  static final String supabaseKey = _AppSecrets.supabaseKey;
}
