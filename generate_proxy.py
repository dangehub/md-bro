
import json
import re

def parse_arb(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    entries = {}
    metadata = {}
    
    for key, value in data.items():
        if key.startswith('@'):
            metadata[key] = value
        else:
            entries[key] = value
            
    return entries, metadata

def generate_dart_code(entries, metadata):
    buffer = []
    
    buffer.append("import '../../localization/l10n_gen/app_localizations.dart';")
    buffer.append("import 'custom_language.dart';")
    buffer.append("")
    buffer.append("/// A proxy class that overrides AppLocalizations with custom dictionary values.")
    buffer.append("class ProxyAppLocalizations extends AppLocalizations {")
    buffer.append("  final AppLocalizations _base;")
    buffer.append("  final CustomLanguage? _custom;")
    buffer.append("")
    buffer.append("  ProxyAppLocalizations(this._base, this._custom) : super(_base.localeName);")
    buffer.append("")

    for key in entries:
        if key.startswith('@'): continue
        
        meta_key = '@' + key
        meta = metadata.get(meta_key, {})
        placeholders = meta.get('placeholders', {})
        
        if not placeholders:
            # Getter
            buffer.append(f"  @override")
            buffer.append(f"  String get {key} => _custom?.translate('{key}') ?? _base.{key};")
        else:
            # Method
            params = []
            replacements = []
            args = []
            
            for p_name, p_def in placeholders.items():
                p_type = p_def.get('type', 'Object')
                # Map some types if necessary, usually String, int, Object are fine
                params.append(f"{p_type} {p_name}")
                replacements.append(f".replaceAll('{{{p_name}}}', {p_name}.toString())")
                args.append(p_name)
            
            signature = f"String {key}({', '.join(params)})"
            
            buffer.append(f"  @override")
            buffer.append(f"  {signature} {{")
            buffer.append(f"    String? custom = _custom?.translate('{key}');")
            buffer.append(f"    if (custom != null) {{")
            
            replacement_chain = "custom" + "".join(replacements)
            buffer.append(f"      return {replacement_chain};")
            buffer.append(f"    }}")
            buffer.append(f"    return _base.{key}({', '.join(args)});")
            buffer.append(f"  }}")
        
        buffer.append("")

    buffer.append("}")
    return "\n".join(buffer)

# Use EN arb as source of truth for structure
entries, metadata = parse_arb('lib/src/localization/app_en.arb')
code = generate_dart_code(entries, metadata)
with open('lib/src/core/localization/proxy_app_localizations.dart', 'w', encoding='utf-8') as f:
    f.write(code)
