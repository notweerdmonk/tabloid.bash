# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <wrdmnk@gmail.com> wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return NOTWEERDMONK
# ----------------------------------------------------------------------------

# Utilities

function get_context() {
  read -r line
  eval $line
  while IFS= read -r line; do
    echo $line
  done
}

#export reader_idx=0
#export reader_str_base=""
#export reader_str=""
#export reader_arr_base=()
#export reader_arr=()
export ctxfile_path=""
export debug_ctxfile_path=""

function create_context_store() {
  local ctxfile="context_store_"$$
  ctxfile_path="/dev/shm/"$ctxfile

  if [[ ! -f "$ctxfile_path" ]]; then
    touch $ctxfile_path
  fi

  #echo $ctxfile_path
}

function create_debug_context_store() {
  local ctxfile="debug_context_store_"$$
  debug_ctxfile_path="/dev/shm/"$ctxfile

  if [[ ! -f "$debug_ctxfile_path" ]]; then
    touch $debug_ctxfile_path
  fi

  #echo $debug_ctxfile_path
}

function get_debug_context_store() {
  echo $debug_ctxfile_path
}

function get_context_store() {
  echo $ctxfile_path
}

function read_key_value_pairs() {
    local file="$1"
    declare -A pairs

    awk -F'=' '{
        key=$1
        value=$2
        pairs[key]=value
    }' < "$file"

    echo "${pairs[@]}"
}

function parse_key_value_file() {
  local file="$1"
  declare -A kv_array

  if [[ ! -f "$file" ]]; then
    echo "File not found: $file"
    return 1
  fi

  # Read file using awk and populate associative array
  while IFS= read -r line; do
    if [[ -n "$line" && "$line" != \#* ]]; then
      key=$(awk -F '=' '{print $1}' <<< "$line" | xargs)
      value=$(awk -F '=' '{print $2}' <<< "$line" | xargs)
      kv_array["$key"]="$value"
    fi
  done < "$file"

  # Export the associative array for further use
  #for key in "${!kv_array[@]}"; do
  #  echo "$key=${kv_array[$key]}"
  #done

  declare -p kv_array
}

function parse_key_value_file2() {
  local file="$1"
  declare -A kv_array

  if [[ ! -f "$file" ]]; then
    echo "File not found: $file" >> /dev/stderr
    return 1
  fi

  # Use awk to process the file and populate the associative array
  while IFS='=' read -r key value; do
    key=$(echo "$key" | xargs) # Trim leading/trailing whitespace
    value=$(echo "$value" | xargs) # Trim leading/trailing whitespace
    [[ -n "$key" && "$key" != \#* ]] && kv_array["$key"]="$value"
  done < <(awk 'NF && $0 !~ /^#/ { print $0 }' "$file")

  # Export the associative array for further use
  #for key in "${!kv_array[@]}"; do
  #  echo "$key=${kv_array[$key]}"
  #done

  declare -p kv_array
}

function dump_key_value_file() {
  local file="$1"
  declare -n kv_array="$2"

  if [[ -z "$file" ]]; then
    echo "Output file not specified." >> /dev/stderr
    return 1
  fi

  # Write the key-value pairs to the file
  {
    for key in "${!kv_array[@]}"; do
      echo "$key=${kv_array[$key]}"
    done
  } > "$file"
}

declare -Ax N=(
  [NumberLiteral]="#NNumberLiteral"
  [StringLiteral]="#NStringLiteral"
  [BoolLiteral]="#NBoolLiteral"
  [FnDecl]="#NFnDecl"
  [FnCall]="#NFnCall"
  [Ident]="#NIdent"
  [Assignment]="#NAssignment"
  [BinaryOp]="#NBinaryOp"
  [IfExpr]="#NIfExpr"
  [ExprGroup]="#NExprGroup"
  [ReturnExpr]="#NReturnExpr"
  [ProgEndExpr]="#NProgEndExpr"
  [PrintExpr]="#NPrintExpr"
  [InputExpr]="#NInputExpr"
)

declare -Ax T=(
  [LParen]="#TLParen"
  [RParen]="#TRParen"
  [Comma]="#TComma"
  [DiscoverHowTo]="#TDiscoverHowTo"
  [With]="#TWith"
  [Of]="#TOf"
  [RumorHasIt]="#TRumorHasIt"
  [WhatIf]="#TWhatIf"
  [LiesBang]="#TLiesBang"
  [EndOfStory]="#TEndOfStory"
  [ExpertsClaim]="#TExpertsClaim"
  [ToBe]="#TToBe"
  [YouWontWantToMiss]="#TYouWontWantToMiss"
  [LatestNewsOn]="#TLatestNewsOn"
  [TotallyRight]="#TTotallyRight"
  [CompletelyWrong]="#TCompletelyWrong"
  [IsActually]="#TIsActually"
  [And]="#TAnd"
  [Or]="#TOr"
  [Plus]="#TPlus"
  [Minus]="#TMinus"
  [Times]="#TTimes"
  [DividedBy]="#TDividedBy"
  [Modulo]="#TModulo"
  [Beats]="#TBeats"
  [SmallerThan]="#TSmallerThan"
  [ShockingDevelopment]="#TShockingDevelopment"
  [PleaseLikeAndSubscribe]="#TPleaseLikeAndSubscribe"
)

declare -ax BINARY_OPS=(
  ${T[IsActually]}
  ${T[And]}
  ${T[Or]}
  ${T[Plus]}
  ${T[Minus]}
  ${T[Times]}
  ${T[DividedBy]}
  ${T[Modulo]}
  ${T[Beats]}
  ${T[SmallerThan]}
)

function create_symbol_N() {
  declare -Agx N=(
    [NumberLiteral]="#NNumberLiteral"
    [StringLiteral]="#NStringLiteral"
    [BoolLiteral]="#NBoolLiteral"
    [FnDecl]="#NFnDecl"
    [FnCall]="#NFnCall"
    [Ident]="#NIdent"
    [Assignment]="#NAssignment"
    [BinaryOp]="#NBinaryOp"
    [IfExpr]="#NIfExpr"
    [ExprGroup]="#NExprGroup"
    [ReturnExpr]="#NReturnExpr"
    [ProgEndExpr]="#NProgEndExpr"
    [PrintExpr]="#NPrintExpr"
    [InputExpr]="#NInputExpr"
  )
}
  
export -f create_symbol_N

function create_symbol_T() {
  declare -Agx T=(
    [LParen]="#TLParen"
    [RParen]="#TRParen"
    [Comma]="#TComma"
    [DiscoverHowTo]="#TDiscoverHowTo"
    [With]="#TWith"
    [Of]="#TOf"
    [RumorHasIt]="#TRumorHasIt"
    [WhatIf]="#TWhatIf"
    [LiesBang]="#TLiesBang"
    [EndOfStory]="#TEndOfStory"
    [ExpertsClaim]="#TExpertsClaim"
    [ToBe]="#TToBe"
    [YouWontWantToMiss]="#TYouWontWantToMiss"
    [LatestNewsOn]="#TLatestNewsOn"
    [TotallyRight]="#TTotallyRight"
    [CompletelyWrong]="#TCompletelyWrong"
    [IsActually]="#TIsActually"
    [And]="#TAnd"
    [Or]="#TOr"
    [Plus]="#TPlus"
    [Minus]="#TMinus"
    [Times]="#TTimes"
    [DividedBy]="#TDividedBy"
    [Modulo]="#TModulo"
    [Beats]="#TBeats"
    [SmallerThan]="#TSmallerThan"
    [ShockingDevelopment]="#TShockingDevelopment"
    [PleaseLikeAndSubscribe]="#TPleaseLikeAndSubscribe"
  )
}
  
export -f create_symbol_T

function create_symbol_BINARY_OPS() {
  declare -agx BINARY_OPS=(
    ${T[IsActually]}
    ${T[And]}
    ${T[Or]}
    ${T[Plus]}
    ${T[Minus]}
    ${T[Times]}
    ${T[DividedBy]}
    ${T[Modulo]}
    ${T[Beats]}
    ${T[SmallerThan]}
  )
}

export -f create_symbol_BINARY_OPS

function source_context() {
  #local ctx=$(parse_key_value_file2 $(get_context_store))
  #local ctx=$(cat $(get_context_store))
  #echo "$ctx"

  local ctxdata=""
  {
    while IFS= read -r line; do
      #echo $line
      # add regex check
      ctxdata=$ctxdata$line
    done 
  } < "$(get_context_store)"

  #eval "$ctx"
  #for key in "${!kv_array[@]}"; do
  #  echo "${kv_array[$key]}"
  #  eval "${kv_array[$key]}"
  #done

  eval "$ctxdata"
  for key in "${!ctx[@]}"; do
    local ctxstr="${ctx[$key]}"
    echo -n "$ctxstr"
    if [[ -n "$ctxstr" ]]; then
      echo ";"
    fi
    #eval "${ctx[$key]}"
  done
}

function source_debug_context() {
  #local ctx=$(parse_key_value_file2 $(get_context_store))
  #local ctx=$(cat $(get_context_store))
  #echo "$ctx"

  local ctxdata=""
  {
    while IFS= read -r line; do
      #echo $line
      # add regex check
      ctxdata=$ctxdata$line
    done 
  } < "$(get_debug_context_store)"

  #eval "$ctx"
  #for key in "${!kv_array[@]}"; do
  #  echo "${kv_array[$key]}"
  #  eval "${kv_array[$key]}"
  #done

  eval "$ctxdata"
  for key in "${!ctx[@]}"; do
    local ctxstr="${ctx[$key]}"
    echo -n "$ctxstr"
    if [[ -n "$ctxstr" ]]; then
      echo ";"
    fi
    #eval "${ctx[$key]}"
  done
}

function dump_context() {
  #declare -n ctxname=$1
  #local ctxname=$1
  #dump_key_value_file $(get_context_store) ${ctxname}

  #declare -A ctx=(
  #  [reader_idx]=$(declare -p reader_idx)
  #  [reader_str]=$(declare -p reader_str)
  #  [reader_str_base]=$(declare -p reader_str_base)
  #)
  #dump_key_value_file $(get_context_store) ctx

  #declare -A ctx=(
  #  [reader_idx]=$(declare -g -p reader_idx)
  #  [reader_str]=$(declare -g -p reader_str)
  #  [reader_str_base]=$(declare -g -p reader_str_base)
  #)
  #echo $(declare -p ctx) > $(get_context_store)
  declare -A ctx=(
    [reader_idx]=$(declare -g -p $1)
    [reader_str]=$(declare -g -p $2)
    [reader_str_base]=$(declare -g -p $3)
    [reader_arr]=$(declare -g -p $4)
    [reader_arr_base]=$(declare -g -p $5)
    [scopes]=$(declare -g -p $6)
  )
  echo "$(declare -p ctx)" > $(get_context_store)
}

function dump_debug_context() {
  #declare -n ctxname=$1
  #local ctxname=$1
  #dump_key_value_file $(get_context_store) ${ctxname}

  #declare -A ctx=(
  #  [reader_idx]=$(declare -p reader_idx)
  #  [reader_str]=$(declare -p reader_str)
  #  [reader_str_base]=$(declare -p reader_str_base)
  #)
  #dump_key_value_file $(get_context_store) ctx

  #declare -A ctx=(
  #  [reader_idx]=$(declare -g -p reader_idx)
  #  [reader_str]=$(declare -g -p reader_str)
  #  [reader_str_base]=$(declare -g -p reader_str_base)
  #)
  #echo $(declare -p ctx) > $(get_context_store)
  declare -A ctx=(
    [expr_grp_depth]=$(declare -g -p $1)
  )
  echo "$(declare -p ctx)" > $(get_debug_context_store)
}

function bar() {
  declare -A ctx=([alpha]="beta" [gamma]="theta")
  dump_context ctx
}

function reader_start2() {
  local reader_idx=0
  local reader_str=""
  local reader_str_base=""
  local reader_arr=()
  local reader_arr_base=()
  declare -g -a scopes=("declare -A scope=()")

  if [[ "$1" == "--" ]]; then
    declare -n arrname=$2
    declare -n arrbasename=$3
    reader_arr=("${arrname[@]}")
    reader_arr_base=("${arrbasename[@]}")
  else
    reader_str="$1"
    reader_str_base="$2"
  fi

  unset ctx
  declare -A ctx=(
    [reader_idx]=$(declare -p reader_idx)
    [reader_str]=$(declare -p reader_str)
    [reader_str_base]=$(declare -p reader_str_base)
    [reader_arr]=$(declare -p reader_arr)
    [reader_arr_base]=$(declare -p reader_arr_base)
    [scopes]=$(declare -g -p scopes)
  )

  declare -p ctx
}

export -f reader_start2

function reader_peek2() {
  # load context
  #eval "$ctx"
  local __ctxdata="$(cat "${ctx}")"
  unset ctx
  eval "$__ctxdata"
  for key in "${!ctx[@]}"; do
    eval "${ctx[$key]}"
  done

  if [[ "${#reader_arr[@]}" -eq 0 ]]; then
    echo "${reader_str:$reader_idx:1}"
  else
    echo "${reader_arr[$reader_idx]}"
  fi
}

export -f reader_peek2

function dump_context2() {
  declare -A ctx=(
    [reader_idx]=$(declare -p reader_idx)
    [reader_str]=$(declare -p reader_str)
    [reader_str_base]=$(declare -p reader_str_base)
    [reader_arr]=$(declare -p reader_arr)
    [reader_arr_base]=$(declare -p reader_arr_base)
    [scopes]=$(declare -g -p scopes)
  )

  declare -p ctx
}

export -f dump_context2

# Invoke function with arguments assuming no context change
# Echo the output and return return code
function call() {
  declare -n __ctxdata="$1"
  shift
  declare cmd="$1"
  shift

  local args="$(echo "${@}" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')"

  #echo "call: cmd: ""$cmd" >> /dev/stderr
  #echo "call: arg: ""$@" >> /dev/stderr
  #echo "call: args: ""$args" >> /dev/stderr

  local result="$(
    __result="$(env ctx="${__ctxdata}" bash -c "$cmd \"${args}\"")"; echo $?; echo "$__result"
  )"

  #echo "call: result: ""$result" >> /dev/stderr

  {
    IFS='\n' read -r ret

    IFS= read -r output

  } <<< "$result"

  #echo "call: output: ""$output" >> /dev/stderr
  echo "$output"

  return $ret
}

export -f call

# Invoke function with arguments
# Eval output to update context
# Echo output and return return code
function call2() {
  declare -n __ctxdata="$1"
  shift
  declare cmd="$1"
  shift

  local args="$(echo "${@}" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')"

  #echo "call2: ctxdata: ""${__ctxdata}" >> /dev/stderr
  #echo "call2: cmd: ""$cmd" >> /dev/stderr
  #echo "call2: arg: ""$@" >> /dev/stderr
  #echo "call2: args: ""$args" >> /dev/stderr

  # TODO check for val and ctx keys
  #local result="$(env ctx="${__ctxdata}" bash -c "$cmd $@")"
  #local retcode="$?"

  local result="$(
  #set -x
    __result="$(env ctx="${__ctxdata}" bash -c "$cmd \"${args}\"")"; echo $?; echo "$__result";
  #set +x
  )"

  #echo "call2: result: ""$result" >> /dev/stderr

  {
    IFS='\n' read -r retcode

    IFS= read -r output

  } <<< "$result"

  #echo "call2: output: ""$output" >> /dev/stderr

  eval "$output"

  #__ctxdata="${ret[ctx]}"
  echo "${ret[ctx]}" > "${__ctxdata}"

  echo "${ret[val]}"

  return $retcode
}

export -f call2

# Invoke function with arguments assuming change in context
# Echo output which contains new context and return return code
function call3() {
  declare -n __ctxdata="$1"
  shift
  declare cmd="$1"
  shift

  local args="$(echo "${@}" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')"

  #echo "call3: ctxdata: ""${__ctxdata}" >> /dev/stderr
  #echo "call3: cmd: ""$cmd" >> /dev/stderr
  #echo "call3: arg: ""$@" >> /dev/stderr

  # TODO check for val and ctx keys
  #local result="$(env ctx="${__ctxdata}" bash -c "$cmd $@")"
  #local retcode="$?"

  local result="$(
    __result="$(env ctx="${__ctxdata}" bash -c "$cmd \"${args}\"")"; echo $?; echo "$__result"
  )"

  #echo "call3: result: ""$result" >> /dev/stderr

  {
    IFS='\n' read -r retcode

    IFS= read -r output

  } <<< "$result"

  #echo "call2: output: ""$output" >> /dev/stderr

  eval "${output}"
  echo "${ret[ctx]}" > /dev/shm/tabloid_context

  echo "$output"
  return $retcode
}

export -f call3

function reader_next2() {
  # load context
  #eval "$ctx"
  local __ctxdata="$(cat "${ctx}")"
  unset ctx
  eval "$__ctxdata"
  for key in "${!ctx[@]}"; do
    eval "${ctx[$key]}"
  done

  local idx=$reader_idx
  reader_idx=$(($reader_idx + 1))
  if [[ "${#reader_arr[@]}" -eq 0 ]]; then
    local val="${reader_str:$idx:1}"
  else
    local val="${reader_arr[$idx]}"
  fi

  #unset ctx
  #declare -A ctx=(
  #  [reader_idx]=$(declare -g -p reader_idx)
  #  [reader_str]=$(declare -g -p reader_str)
  #  [reader_str_base]=$(declare -g -p reader_str_base)
  #  [reader_arr]=$(declare -g -p reader_arr)
  #  [reader_arr_base]=$(declare -g -p reader_arr_base)
  #  [scopes]=$(declare -g -p scopes)
  #)
  #declare -p ctx

  #dump context and ret val
  declare -A ret=(
    [val]="$val"
    [ctx]="$(dump_context2)"
  )
  declare -p ret
}

export -f reader_next2

function reader_has_next2() {
  # load context
  #eval "$ctx"
  local __ctxdata="$(cat "${ctx}")"
  unset ctx
  eval "$__ctxdata"
  for key in "${!ctx[@]}"; do
    eval "${ctx[$key]}"
  done

  #echo "reader_has_next2: reader_arr: ""${reader_arr[@]}" >> /dev/stderr

  if [[ "${#reader_arr[@]}" -eq 0 ]]; then
    if [[ $reader_idx -lt ${#reader_str} ]]; then
      return 1
    fi
  else
    if [[ $reader_idx -lt ${#reader_arr[@]} ]]; then
      return 1
    fi
  fi

  return 0
}

export -f reader_has_next2

function reader_backstep2() {
  # load context
  #eval "$ctx"
  local __ctxdata="$(cat "${ctx}")"
  unset ctx
  eval "$__ctxdata"
  for key in "${!ctx[@]}"; do
    eval "${ctx[$key]}"
  done

  reader_idx=$(($reader_idx - 1))

  #dump context and ret val
  declare -A ret=(
    [val]=""
    [ctx]="$(dump_context2)"
  )
  declare -p ret
}

export -f reader_backstep2

function reader_read_until2() {
  # load context
  local ctxdata="$ctx"
  local __ctxdata="$(cat "${ctx}")"
  unset ctx
  eval "$__ctxdata"
  for key in "${!ctx[@]}"; do
    eval "${ctx[$key]}"
  done

  local predicate=$1
  if [[ "${#reader_arr[@]}" -eq 0 ]]; then
    local result=$reader_str_base
  else
    local result=("${reader_arr_base[@]}")
  fi

  #while ! $(call ctxdata reader_has_next2) && $predicate "$(env ctx="$ctxdata" bash -c reader_peek2)"; # we accept false condition for predicate
  while ! $(call ctxdata reader_has_next2) && $predicate "$(call ctxdata reader_peek2)"; # we accept false condition for predicate
  do
    #local newresult="$(reader_next2)"
    eval "$(call3 ctxdata reader_next2)"
    local newresult="${ret[val]}"
    __ctxdata="${ret[ctx]}"
    if [[ "${#reader_arr[@]}" -eq 0 ]]; then
      result="$result""$newresult"
    else
      result+=("$newresult")
    fi
  done
  
  if [[ "${#reader_arr[@]}" -eq 0 ]]; then
    local val="$result"
  else
    local val="${result[@]}"
  fi

  #echo "reader_read_until2: val: ""$val" >> /dev/stderr

  #dump context and ret val
  declare -A ret=(
    [val]="$val"
    [ctx]="$__ctxdata"
  )
  declare -p ret
}

export -f reader_read_until2

  function skip_ws() {
    if [[ -z "$1" || "${1:0:1}" == " " ]]; then
      return 0 # false case, ws found
    else
      return 1 # true case, non-ws found
    fi
  }

  export -f skip_ws

function reader_drop_whitespace2() {
  # load context
  local ctxdata="$ctx"

  function skip_ws() {
    if [[ -z "$1" || "${1:0:1}" == " " ]]; then
      return 0 # false case, ws found
    else
      return 1 # true case, non-ws found
    fi
  }

  export -f skip_ws

  eval "$(env ctx="$ctxdata" bash -c "reader_read_until2 skip_ws")"

  #echo "${ret_copy[ctx]}" > "${ctxdata}"

  declare -A ret_copy
  # copy from ret to ret_copy
  for key in "${!ret[@]}";
  do
    ret_copy[$key]="${ret[$key]}"
  done

  unset ret
  declare -A ret=(
    [val]="${ret_copy[val]}"
    [ctx]="${ret_copy[ctx]}"
  )
  declare -p ret
}

export -f reader_drop_whitespace2

function reader_drop_whitespace3() {
  # load context
  local ctxdata="$ctx"

  function skip_ws() {
    if [[ -z "$1" || "${1:0:1}" == " " ]]; then
      return 0 # false case, ws found
    else
      return 1 # true case, non-ws found
    fi
  }

  export -f skip_ws

  eval "$(call3 ctxdata reader_read_until2 skip_ws)"

  declare -A ret_copy
  # copy from ret to ret_copy
  for key in "${!ret[@]}";
  do
    ret_copy[$key]="${ret[$key]}"
  done

  unset ret
  declare -A ret=(
    [val]="${ret_copy[val]}"
    [ctx]="${ret_copy[ctx]}"
  )
  declare -p ret
}

export -f reader_drop_whitespace3

function reader_expect2() {
  # load context
  local ctxdata="$ctx"
  #eval "$ctx"
  local __ctxdata="$(cat "${ctx}")"
  unset ctx
  eval "$__ctxdata"
  for key in "${!ctx[@]}"; do
    eval "${ctx[$key]}"
  done

  local tok="$1"
  eval "$(env ctx="$ctxdata" bash -c reader_next2)"
  local next="${ret[val]}"
  __ctxdata="${ret[ctx]}"

  if [[ "$next" != "$tok" ]]; then
    local val="Parsing error: expected ""$tok"", got ""$next" >> /dev/stderr
    local retcode=1
  else
    local retcode=0
  fi

  declare -A ret=(
    [val]="$val"
    [ctx]="$__ctxdata"
  )
  declare -p ret

  return $retcode
}

export -f reader_expect2

function reader_expect3() {
  # load context
  #declare -n __re3_ctxdata="$ctx"
  #local __re3_ctxdata="$ctx"
  local ctxdata="$ctx"
  #eval "$ctx"
  #for key in "${!ctx[@]}"; do
  #  eval "${ctx[$key]}"
  #done

  local tok="$1"
  eval "$(call3 ctxdata reader_next2)"

  local next="${ret[val]}"

  if [[ "$next" != "$tok" ]]; then
    local val="Parsing error: expected ""$tok"", got ""$next"
    local retcode=1
  else
    local retcode=0
  fi

  declare -A ret_copy
  # copy from ret to ret_copy
  for key in "${!ret[@]}";
  do
    ret_copy[$key]="${ret[$key]}"
  done

  unset ret
  declare -A ret=(
    [val]="$val"
    [ctx]="${ret_copy[ctx]}"
  )
  declare -p ret

  return $retcode
}

export -f reader_expect3

function wordifier_start2() {
  echo "$(reader_start2 "$@" "")"
}

export -f wordifier_start2

function wordifier_wordify2() {

  # load context
  local ctxdata="$ctx"

  local __ctxdata=""

  function wordify_filter() {
    # return true condition if tok in ('(', ')', ',') or ws
    local tok="$1"
    #tok="$(echo "$tok" | xargs)" # trim
    tok="$(echo "$tok" | tr -d " ")" # trim
    #echo "filter: tok: ""$tok"
    if [[ -z "$tok" ]]; then
      return 1 # true condition, ws found
    fi
    if [[ "$tok" =~ ^[(),] ]]; then
      return 1 # true condition, ('(', ')', ',') found
    fi
    # return false condition
    return 0
  }

  export -f wordify_filter

  local wordifier_tokens=()

  #echo "wordifier_wordify2: reader_arr: ""$(cat $ctxdata)" >> /dev/stderr

  while ! $(call ctxdata reader_has_next2);
  do
    eval "$(call3 ctxdata reader_next2)"
    local next="${ret[val]}"
    __ctxdata="${ret[ctx]}"

    #echo "wordify: next: ""$next" >> /dev/stderr

    case $next in
      "(")
        wordifier_tokens+=("(")
        ;;
      ")")
        wordifier_tokens+=(")")
        ;;
      ",")
        wordifier_tokens+=(",")
        ;;
      '"')
        #eval "$(wordifier_wordify_string "$next")"
        #for strtok in ${wordify_string_tokens[@]};
        #do
        #  wordifier_tokens+=("$strtok")
        #done
        eval "$(call3 ctxdata wordifier_wordify_string2 "$next")"
        wordifier_tokens+=("${ret[val]}")
        __ctxdata="${ret[ctx]}"
        ;;
      "'")
        #eval "$(wordifier_wordify_string "$next")"
        #for strtok in ${wordify_string_tokens[@]};
        #do
        #  wordifier_tokens+=("$strtok")
        #done
        eval "$(call3 ctxdata wordifier_wordify_string2 "$next")"
        wordifier_tokens+=("${ret[val]}")
        __ctxdata="${ret[ctx]}"
        ;;
      *)
        # read until ws
        call2 ctxdata reader_backstep2 1>/dev/null
        eval "$(call3 ctxdata reader_read_until2 wordify_filter)"

        local tok="${ret[val]}"
        __ctxdata="${ret[ctx]}"
        #echo "wordify: tok: ""$tok"
        #echo "wordifier_wordify2: tok read till ws: ""$tok" >> /dev/stderr
        wordifier_tokens+=("$tok")
        ;;
    esac

    call2 ctxdata reader_drop_whitespace3 1>/dev/null
  done

  #echo "wordifier_wordify2: tokens: ""$(declare -p wordifier_tokens)" >> /dev/stderr
  #echo "${wordifier_tokens[@]}"
  #for tok in ${wordifier_tokens[@]};
  #do
  #  echo "token: ""$tok"
  #done
  #declare -p wordifier_tokens

  declare -A ret=(
    [val]="$(declare -p wordifier_tokens)"
    [ctx]="$__ctxdata"
  )
  declare -p ret

}

export -f wordifier_wordify2

function wordifier_wordify_string2() {

  # load context
  local ctxdata="$ctx"
  local __ctxdata=""

  local __endchar="$1"
  export __endchar

  function filter() {
    if [[ "$1" == "$__endchar" ]]; then
      return 1
    else
      return 0
    fi
  }

  export -f filter

  local accum=""
  eval "$(call3 ctxdata reader_read_until2 filter)"
  accum="$accum""${ret[val]}"
  __ctxdata="${ret[ctx]}"

  #echo "wordify_string: 1accum: ""$accum"
  while ! ends_with "$accum" "\\" && $(call ctxdata reader_has_next2);
  do
    accum="${accum:0:-1}"
    #echo "wordify_string: 2accum: ""$accum"
    call2 ctxdata reader_next2 1>/dev/null # end char
    eval "$(call3 ctxdata reader_read_until2 filter)"
    accum="$accum""${ret[val]}"
    __ctxdata="${ret[ctx]}"
    #echo "wordify_string: 3accum: ""$accum"
  done

  unset __endchar

  #call2 ctxdata reader_next2 1>/dev/null # throw away closing char
  #echo -n "wordifier_wordify_string2: throw away next closing char: " >> /dev/stderr
  #call2 ctxdata reader_next2 >> /dev/stderr # throw away closing char
  eval "$(call3 ctxdata reader_next2)"
  __ctxdata="${ret[ctx]}"

  #echo "wordifier_wordify_string2: accum: ""$accum" >> /dev/stderr

  declare -A ret=(
    [val]='"'"$accum"
    [ctx]="$__ctxdata"
  )
  declare -p ret
}

export -f wordifier_wordify_string2

function tokenize2() {
  #echo "tokenize2: arg: ""$@" >> /dev/stderr
  local prog="$@"
  
  create_symbol_T

  local ctxdata="/dev/shm/tabloid_context"
  local __ctxdata="$(wordifier_start2 "$prog")"

  echo "${__ctxdata}" > "${ctxdata}"

  eval "$(call3 ctxdata wordifier_wordify2)"
  __ctxdata="${ret[ctx]}"
  eval "${ret[val]}"

  base=()
  __ctxdata="$(reader_start2 -- wordifier_tokens base)"
  echo "${__ctxdata}" > "${ctxdata}"

  declare -a tokens=()

  while ! $(call ctxdata reader_has_next2) ;
  do
    eval "$(call3 ctxdata reader_next2)"
    local next="${ret[val]}"
    __ctxdata="${ret[ctx]}"

    case "$next" in
      "DISCOVER")
        eval "$(call3 ctxdata reader_expect3 "HOW")"
        __ctxdata="${ret[ctx]}"
        eval "$(call3 ctxdata reader_expect3 "TO")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[DiscoverHowTo]})
        ;;
      "WITH")
        tokens+=(${T[With]})
        ;;
      "OF")
        tokens+=(${T[Of]})
        ;;
      "RUMOR")
        eval "$(call3 ctxdata reader_expect3 "HAS")"
        __ctxdata="${ret[ctx]}"
        eval "$(call3 ctxdata reader_expect3 "IT")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[RumorHasIt]})
        ;;
      "WHAT")
        eval "$(call3 ctxdata reader_expect3 "IF")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[WhatIf]})
        ;;
      "LIES!")
        tokens+=(${T[LiesBang]})
        ;;
      "END")
        eval "$(call3 ctxdata reader_expect3 "OF")"
        __ctxdata="${ret[ctx]}"
        eval "$(call3 ctxdata reader_expect3 "STORY")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[EndOfStory]})
        ;;
      "EXPERTS")
        eval "$(call3 ctxdata reader_expect3 "CLAIM")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[ExpertsClaim]})
        ;;
      "TO")
        eval "$(call3 ctxdata reader_expect3 "BE")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[ToBe]})
        ;;
      "YOU")
        eval "$(call3 ctxdata reader_expect3 "WON'T")"
        __ctxdata="${ret[ctx]}"
        eval "$(call3 ctxdata reader_expect3 "WANT")"
        __ctxdata="${ret[ctx]}"
        eval "$(call3 ctxdata reader_expect3 "TO")"
        __ctxdata="${ret[ctx]}"
        eval "$(call3 ctxdata reader_expect3 "MISS")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[YouWontWantToMiss]})
        ;;
      "LATEST")
        eval "$(call3 ctxdata reader_expect3 "NEWS")"
        __ctxdata="${ret[ctx]}"
        eval "$(call3 ctxdata reader_expect3 "ON")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[LatestNewsOn]})
        ;;
      "IS")
        eval "$(call3 ctxdata reader_expect3 "ACTUALLY")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[IsActually]})
        ;;
      "AND")
        tokens+=(${T[And]})
        ;;
      "OR")
        tokens+=(${T[Or]})
        ;;
      "PLUS")
        tokens+=(${T[Plus]})
        ;;
      "MINUS")
        tokens+=(${T[Minus]})
        ;;
      "TIMES")
        tokens+=(${T[Times]})
        ;;
      "DIVIDED")
        eval "$(call3 ctxdata reader_expect3 "BY")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[DividedBy]})
        ;;
      "MODULO")
        tokens+=(${T[Modulo]})
        ;;
      "BEATS")
        tokens+=(${T[Beats]})
        ;;
      "SMALLER")
        eval "$(call3 ctxdata reader_expect3 "THAN")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[SmallerThan]})
        ;;
      "SHOCKING")
        eval "$(call3 ctxdata reader_expect3 "DEVELOPMENT")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[ShockingDevelopment]})
        ;;
      "PLEASE")
        eval "$(call3 ctxdata reader_expect3 "LIKE")"
        __ctxdata="${ret[ctx]}"
        eval "$(call3 ctxdata reader_expect3 "AND")"
        __ctxdata="${ret[ctx]}"
        eval "$(call3 ctxdata reader_expect3 "SUBSCRIBE")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[PleaseLikeAndSubscribe]})
        ;;
      "TOTALLY")
        eval "$(call3 ctxdata reader_expect3 "RIGHT")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[TotallyRight]})
        ;;
      "COMPLETELY")
        eval "$(call3 ctxdata reader_expect3 "WRONG")"
        __ctxdata="${ret[ctx]}"
        tokens+=(${T[CompletelyWrong]})
        ;;
        "(")
        tokens+=(${T[LParen]})
        ;;
      ")")
        tokens+=(${T[RParen]})
        ;;
      ",")
        tokens+=(${T[Comma]})
        ;;
      *)
        tokens+=("$next")
        #if [[ $next =~ ^-?[0-9]+$ ]]; then
        #  tokens+=("$next}")
        #fi
        ;;
          
    esac

  done

  declare -A ret=(
    [val]="$(declare -p tokens)"
    [ctx]="${__ctxdata}"
  )
  declare -p ret
}

export -f tokenize2

function parser_start2() {
  local tokenarrname=$1[@]
  local tokens=("${!tokenarrname}")
  local base=()

  echo "$(reader_start2 -- tokens base)"
}

export -f parser_start2

function parser_expect_ident_string2() {
  # load context
  local ctxdata="$ctx"
  local __ctxdata=""

  eval "$(call3 ctxdata reader_next2)"
  local ident="${ret[val]}"
  __ctxdata="${ret[ctx]}"

  local retcode=1
  local val=""
  if [[ ! "$ident" =~ ^-?[0-9]+$ ]] && starts_with "$ident" '"'; then
    val="$ident"
    retcode=0
  else
    echo "parsing error: expected identifier, got $ident" >> /dev/stderr
    val="parsing error: expected identifier, got $ident"
  fi

  declare -A ret=(
    [val]="${val}"
    [ctx]="${__ctxdata}"
  )
  declare -p ret

  return "${retcode}"
}

export -f parser_expect_ident_string2

function parser_fncall2() {
  # load context
  local ctxdata="$ctx"
  local __ctxdata=""

  create_symbol_T
  create_symbol_N

  # variable is name expr
  eval "$1"

  # make copy of expr
  declare -A expr_copy=()
  for expr_key in "${!expr[@]}";
  do
    expr_copy[$expr_key]="${expr[$expr_key]}"
  done

  eval "$(call3 ctxdata reader_expect3 "${T[Of]}")"
  __ctxdata="${ret[ctx]}"

  eval "$(call3 ctxdata parser_expr2)"
  unset expr
  local expr="${ret[val]}"
  __ctxdata="${ret[ctx]}"

  local args=("$expr")

  while [[ "$(call ctxdata reader_peek2)" == "${T[Comma]}" ]];
  do
    call2 ctxdata reader_next2 1>/dev/null # comma

    eval "$(call3 ctxdata parser_expr2)"
    exprs+=("${ret[val]}")
    __ctxdata="${ret[ctx]}"
  done

  unset expr
  declare -A expr=()
  # copy back
  for expr_key in "${!expr_copy[@]}";
  do
    expr[$expr_key]="${expr_copy[$expr_key]}"
  done

  declare -A tmp=(
    [type]="${N[FnCall]}"
    [fn]="$(declare -p expr)"
    [args]="$(declare -p args)"
  )

  # copy back
  for tmp_key in "${!tmp[@]}";
  do
    expr[$tmp_key]="${tmp[$tmp_key]}"
  done

  declare -A ret=(
    [val]="$(declare -p expr)"
    [ctx]="${__ctxdata}"
  )
  declare -p ret
  return 0
}

export -f parser_fncall2

function parser_atom2() {
  # load context
  local ctxdata="${ctx}"
  local __ctxdata=""

  create_symbol_T
  create_symbol_N

  eval "$(call3 ctxdata reader_next2)"
  local next="${ret[val]}"
  __ctxdata="${ret[ctx]}"

  if [[ "$next" == "${T[TotallyRight]}" ]]; then
    declare -A expr=(
      [type]="${N[BoolLiteral]}"
      [val]="true" # true
    )
    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  elif [[ "$next" == "${T[CompletelyWrong]}" ]]; then
    declare -A expr=(
      [type]="${N[BoolLiteral]}"
      [val]="false" # false
    )
    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  elif [[ "$next" == "${T[DiscoverHowTo]}" ]]; then
    # function literal
    eval "$(call3 ctxdata reader_next2)"
    local fnname="${ret[val]}"
    __ctxdata="${ret[ctx]}"

    local args=()

    if [[ "$(call ctxdata reader_peek2)" == "${T[With]}" ]]; then
      call2 ctxdata reader_next2 1>/dev/null # with

      # with args
      eval "$(call3 ctxdata parser_expect_ident_string2)"
      args+=("${ret[val]}")
      __ctxdata="${ret[ctx]}"

      while [[ "$(call ctxdata reader_peek2)" == "${T[Comma]}" ]];
      do
        call2 ctxdata reader_next2 1>/dev/null # comma
        eval "$(call3 ctxdata parser_expect_ident_string2)"
        args+=("${ret[val]}")
        __ctxdata="${ret[ctx]}"
      done

    fi

    eval "$(call3 ctxdata parser_expr2)"
    local expr="${ret[val]}"
    __ctxdata="${ret[ctx]}"

    declare -A tmp=(
      [type]="${N[FnDecl]}"
      [name]="$fnname"
      [args]="$(declare -p args)"
      [body]="${expr}"
    )

    unset expr
    declare -A expr
    # copy from tmp to expr
    for key in "${!tmp[@]}";
    do
      expr[$key]="${tmp[$key]}"
    done

    unset ret
    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  elif [[ "$next" == "${T[RumorHasIt]}" ]]; then
    unset exprs
    declare -a exprs=()

    while ! $(call ctxdata reader_has_next2) && [[ ! "$(call ctxdata reader_peek2)" == "${T[EndOfStory]}" ]];
    do
      eval "$(call3 ctxdata parser_expr2)"
      exprs+=("${ret[val]}")
      __ctxdata="${ret[ctx]}"
    done
    eval "$(call3 ctxdata reader_expect3 "${T[EndOfStory]}")"
    __ctxdata="${ret[ctx]}"

    declare -A expr=(
      [type]="${N[ExprGroup]}"
      [exprs]="$(declare -p exprs)"
    )

    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  elif [[ "$next" == "${T[LParen]}" ]]; then
    unset exprs
    declare -a exprs=()

    while ! $(call ctxdata reader_has_next2) && [[ ! "$(call ctxdata reader_peek2)" == "${T[RParen]}" ]];
    do
      eval "$(call3 ctxdata parser_expr2)"
      exprs+=("${ret[val]}")
      __ctxdata="${ret[ctx]}"
    done

    declare -A expr=(
      [type]="${N[ExprGroup]}"
      [exprs]="$(declare -p exprs)"
    )

    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  elif [[ "$next" =~ ^-?[0-9]+$ ]]; then
    # number
    unset expr
    declare -A expr=(
      [type]="${N[NumberLiteral]}"
      [val]="$next"
    )

    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  elif [[ ! "$next" =~ ^-?[0-9]+$ ]]; then
    # string
    if ! starts_with "$next" '"'; then
      declare -A expr=(
        [type]="${N[StringLiteral]}"
        [val]="${next:1}"
      )

      declare -A ret=(
        [val]="$(declare -p expr)"
        [ctx]="${__ctxdata}"
      )
      declare -p ret
      return 0

    fi

    unset expr
    declare -A expr=(
      [type]="${N[Ident]}"
      [val]="$next"
    )

    if [[ "$(call ctxdata reader_peek2)" == "${T[Of]}" ]]; then
      eval "$(call3 ctxdata parser_fncall2 "$(declare -p expr)")"
      local expr="${ret[val]}"
      __ctxdata="${ret[ctx]}"

      #echo "parser_atom2: parse fncall: expr: ""$expr" >> /dev/stderr

      unset ret
      declare -A ret=(
        [val]="${expr}"
        [ctx]="${__ctxdata}"
      )
      declare -p ret
      return 0
    fi

    #echo "parser_atom2: parse identifier: expr: ""$(declare -p expr)" >> /dev/stderr

    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  else
    #"echo "Parsing error: expected ident, literal, or block, got ${
    #        next.toString()
    #    } before ${this.tokens.peek().toString()}`);
    echo "Parsing error: expected ident, literal, or block, got ${next}" >> /dev/stderr
    return 1
  fi
}

export -f parser_atom2

function parser_expr2() {
  # load context
  local ctxdata="$ctx"
  local __ctxdata=""

  create_symbol_T
  create_symbol_N

  eval "$(call3 ctxdata reader_next2)"
  local next="${ret[val]}"
  __ctxdata="${ret[ctx]}"

  if [[ "${next}" == "${T[WhatIf]}" ]]; then
    # if expr
    eval "$(call3 ctxdata parser_expr2)"
    local cond="${ret[val]}"
    __ctxdata="${ret[ctx]}"

    eval "$(call3 ctxdata parser_expr2)"
    local ifbody="${ret[val]}"
    __ctxdata="${ret[ctx]}"

    local elsebody=""
    if [[ "$(call ctxdata reader_peek2)" == "${T[LiesBang]}" ]]; then
      call2 ctxdata reader_next2 1>/dev/null # TLiesBang
      eval "$(call3 ctxdata parser_expr2)"
      elsebody="${ret[val]}"
      __ctxdata="${ret[ctx]}"
    fi

    declare -A expr=(
      [type]="${N[IfExpr]}"
      [cond]="$cond"
      [ifbody]="$ifbody"
      [elsebody]="$elsebody"
    )

    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  elif [[ "${next}" == "${T[ExpertsClaim]}" ]]; then
    # assignment
    eval "$(call3 ctxdata parser_expect_ident_string2)"
    local name="${ret[val]}"
    __ctxdata="${ret[ctx]}"

    eval "$(call3 ctxdata reader_expect3 "${T[ToBe]}")"
    __ctxdata="${ret[ctx]}"

    eval "$(call3 ctxdata parser_expr2)"
    local val="${ret[val]}"
    __ctxdata="${ret[ctx]}"

    #echo "parser_expr: ExpertsClaim: name: ""$name" >> /dev/stderr
    #echo "parser_expr: ExpertsClaim: val: ""$val" >> /dev/stderr

    unset expr
    declare -A expr=(
        [type]="${N[Assignment]}"
        [name]="$name"
        [val]="$val"
    )

    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  elif [[ "${next}" == "${T[ShockingDevelopment]}" ]]; then
    # return
    eval "$(call3 ctxdata parser_expr2)"
    local val="${ret[val]}"
    __ctxdata="${ret[ctx]}"

    #echo "parser_expr: ShockingDevelopment: val: ""$val" >> /dev/stderr
    unset expr
    declare -A expr=(
        [type]="${N[ReturnExpr]}"
        [val]="$val"
    )

    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  elif [[ "$next" == "${T[PleaseLikeAndSubscribe]}" ]]; then
    # prog end
    declare -A expr=(
        [type]="${N[ProgEndExpr]}"
    )

    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  elif [[ "$next" == "${T[YouWontWantToMiss]}" ]]; then
    # print expr

    eval "$(call3 ctxdata parser_expr2)"
    local val="${ret[val]}"
    __ctxdata="${ret[ctx]}"

    declare -A expr=(
      [type]="${N[PrintExpr]}"
      [val]="$val"
    )
    #unset expr
    #declare -A expr
    ## copy from ret to expr
    #for key in "${!ret[@]}";
    #do
    #  expr[$key]="${ret[$key]}"
    #done

    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  elif [[ "$next" == "${T[LatestNewsOn]}" ]]; then
    # input expr
    local val="$(parser_expr)"
    declare -A expr=(
        [type]="${N[InputExpr]}"
        [val]="$val"
    )

    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0
  
  fi

  call2 ctxdata reader_backstep2 1>/dev/null

  unset ret
  eval "$(call3 ctxdata parser_atom2)"
  __ctxdata="${ret[ctx]}"

  create_symbol_BINARY_OPS

  if ! array_contains "$(call ctxdata reader_peek2)" "${BINARY_OPS[@]}"; then
    unset expr
    declare -A expr=(
        [type]="${N[BinaryOp]}"
        [op]=""
        [left]=""
        [right]=""
    )

    # infix binary ops
    expr[left]="${ret[val]}"
    #echo "parser_expr: Binary op found: left: ""${ret[left]}" >> /dev/stderr

    eval "$(call3 ctxdata reader_next2)"
    local op="${ret[val]}"
    __ctxdata="${ret[ctx]}"
    #echo "parser_expr: Binary op found: op: ""$op" >> /dev/stderr

    expr[op]="$op"

    unset ret
    eval "$(call3 ctxdata parser_atom2)"
    __ctxdata="${ret[ctx]}"

    expr[right]="${ret[val]}"
    #echo "parser_expr: Binary op found: right: ""${ret[right]}" >> /dev/stderr
    
    unset ret
    declare -A ret=(
      [val]="$(declare -p expr)"
      [ctx]="${__ctxdata}"
    )
    declare -p ret
    return 0

  fi


  local val="${ret[val]}"
  unset ret
  declare -A ret=(
    [val]="${val}"
    [ctx]="${__ctxdata}"
  )
  declare -p ret

  return 0
}

export -f parser_expr2

function parser_parse2() {
  # load context
  local ctxdata="${ctx}"
  local __ctxdata=""

  create_symbol_T
  create_symbol_N

  declare -g -a nodes=()

  while ! $(call ctxdata reader_has_next2) ;
  do
    eval "$(call3 ctxdata parser_expr2)"
    nodes+=("${ret[val]}")
    __ctxdata="${ret[ctx]}"
  done

  # get last node
  # variable is named expr
  eval "${nodes[-1]}"
  if [[ ! "${expr[type]}" == "${N[ProgEndExpr]}" ]]; then
    echo "Parsing error: A Tabloid program MUST end with PLEASE LIKE AND SUBSCRIBE" >> /dev/stderr
  fi

  declare -A ret=(
    [val]="$(declare -p nodes)"
    [ctx]="${__ctxdata}"
  )
  declare -p ret
}

export -f parser_parse2

function env_eval2() {
  # clear from previous call
  unset expr

  # variable name is expr
  #eval "$1"
  eval "$(cat "$1")"

  # clear from previous call
  unset atom
  declare -A atom
  # copy from expr to atom
  for key in "${!expr[@]}";
  do
    atom[$key]="${expr[$key]}"
  done

  # load ctx
  local ctxdata="${ctx}"
  local __ctxdata="$(cat "${ctx}")"
  unset ctx
  eval "$__ctxdata"
  for key in "${!ctx[@]}"; do
    eval "${ctx[$key]}"
  done

  #eval "$(source_debug_context)"
  #expr_grp_depth=$(($expr_grp_depth + 1))
  #dump_debug_context expr_grp_depth

  unset scope
  unset scope_idx
  # scopes array contains each scope as declare -p scope
  if [[ "${#scopes[@]}" -gt 0 ]]; then
    eval "${scopes[-1]}"
    local scope_idx=$((${#scopes[@]} - 1))
  else
    local scope=()
    local scope_idx=0
  fi

  unset expr

  case "${atom[type]}" in
    "#NNumberLiteral")
      ;&
    "#NStringLiteral")
      ;&
    "#NBoolLiteral")
      declare expr="${atom[val]}"

      declare -A ret=(
        [val]="$(declare -p expr)"
        [ctx]="${__ctxdata}"
      )
      declare -p ret

      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NFnDecl")
      declare -A expr=()
      # copy from atom to expr
      for key in "${!atom[@]}";
      do
        expr[$key]="${atom[$key]}"
      done

      #echo "env_eval2: FnDecl: expr: ""$(declare -p expr)" >> /dev/stderr

      scope["${atom[name]}"]="$(declare -p expr)"
      scopes[$scope_idx]="$(declare -p scope)"

      declare -A ret=(
        [val]="$(declare -p expr)"
        [ctx]="$(dump_context2)"
      )
      # save context to file
      echo "${ret[ctx]}" > "${ctxdata}"

      declare -p ret

      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NFnCall")
      local fn="${atom[fn]}"
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: fn: ""$fn" >> /dev/stderr

      echo "${fn}" > /dev/shm/tabloid_exprs
      eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
      __ctxdata="${ret[ctx]}"
      fn="${ret[val]}"
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: eval fn: ""$fn" >> /dev/stderr

      # map eval to atom[args]
      # variable is named args
      eval "${atom[args]}"
      declare -a args_copy=()
      for key in "${!args[@]}";
      do
        local arg="${args[$key]}"

        echo "${arg}" > /dev/shm/tabloid_exprs
        eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
        __ctxdata="${ret[ctx]}"
        local result="${ret[val]}"
        #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: result: ""$result" >> /dev/stderr
        #echo "env_eval: FnCall: args key: ""$key"" result: ""$result" >> /dev/stderr
        # make copy of args
        args_copy[$key]="$(echo "$result")"
      done

      unset scope
      declare -A scope=()

      # variable is named expr
      eval "$fn"

      unset args
      # variable is named args
      eval "${expr[args]}"

      # this args corresponds to function argument identifiers literals
      # args_copy contains actual evaluated argument values
      for key in "${!args[@]}";
      do
        scope[${args[$key]}]="${args_copy[$key]}"
      done

      scopes+=("$(declare -p scope)")
      #echo "env_eval: FnCall: scope: ""$(declare -p scope)" >> /dev/stderr
      __ctxdata="$(dump_context2)"
      # save context to file
      echo "${__ctxdata}" > "${ctxdata}"

      echo "${__ctxdata}" > /dev/shm/tabloid_context

      local fnbody="${expr[body]}"

      #echo "env_eval2: NFnCall: fnbody: ""$fnbody" >> /dev/stderr

      echo "${fnbody}" > /dev/shm/tabloid_exprs
      eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
      __ctxdata="${ret[ctx]}"
      local fnresult="${ret[val]}"

      #echo "env_eval2: NFnCall: fnresult: ""$fnresult" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: fnname: ""${atom[val]}" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: fnargs: ""${args[@]}" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: args: ""${args_copy[@]}" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: fnresult: ""$fnresult" >> /dev/stderr
      #eval "$fnresult"
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: eval fnresult: ""$fnresult" >> /dev/stderr

      # pop latest scope
      unset scopes[-1]
      __ctxdata="$(dump_context2)"
      echo "${__ctxdata}" > /dev/shm/tabloid_context
      # save context to file
      echo "${__ctxdata}" > "${ctxdata}"

      declare -A ret=(
        [val]="${fnresult}"
        [ctx]="${__ctxdata}"
      )
      declare -p ret

      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NIdent")
      #echo "[""$expr_grp_depth""] : ""env_eval: NIdent: val: ""${atom[val]}" >> /dev/stderr

      local i=$((${#scopes[@]} - 1))
      while [[ $i -ge 0 ]];
      do
          #echo "[""$expr_grp_depth""] : ""env_eval: NIdent: val: ""${atom[val]}" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: NIdent: current scope: ""${scopes[$i]}" >> /dev/stderr
          #echo "env_eval: NIdent: val: ""${atom[val]}" >> /dev/stderr
          #echo "env_eval: NIdent: current scope: ""${scopes[$i]}" >> /dev/stderr
          unset scope
          eval "${scopes[$i]}"
          #echo "[""$expr_grp_depth""] : ""env_eval: NIdent: current scope keys: ""${!scope[@]}" >> /dev/stderr
          #echo "env_eval: NIdent: current scope keys: ""${!scope[@]}" >> /dev/stderr
          if ! array_contains "${atom[val]}" "${!scope[@]}"; then
            #echo "[""$expr_grp_depth""] : ""env_eval: NIdent: scope: ""${scope[${atom[val]}]}" >> /dev/stderr
            #echo "env_eval: NIdent: scope: ""${scope[${atom[val]}]}" >> /dev/stderr

            declare -A ret=(
              [val]="${scope[${atom[val]}]}"
              [ctx]="${__ctxdata}"
            )
            declare -p ret

            #expr_grp_depth=$(($expr_grp_depth - 1))
            #dump_debug_context expr_grp_depth
            return 0
          fi
          i=$(($i - 1))
      done
      #echo "[""$expr_grp_depth""] : ""Runtime error: Undefined variable ""${atom[val]}" >> /dev/stderr
      ;;

    "#NAssignment")
      #eval "$(source_context)"

      local val="${atom[val]}"
      #echo "[""$expr_grp_depth""] : ""env_eval: NAssignment: val: ""$val" >> /dev/stderr

      echo "${val}" > /dev/shm/tabloid_exprs
      eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
      __ctxdata="${ret[ctx]}"

      eval $"${ret[val]}"
      val="${ret[val]}"

      scope["${atom[name]}"]="$val"
      scopes[$scope_idx]="$(declare -p scope)"

      #echo "env_eval2: NAssignment: ctxdata: ""$ctxdata" >> /dev/stderr
      #echo "env_eval2: NAssignment: dump_context2: ""$(dump_context2)" >> /dev/stderr
      #echo "env_eval2: NAssignment: val: ""$val" >> /dev/stderr

      declare -A ret=(
        [val]="${val}"
        [ctx]="$(dump_context2)"
      )
      # save context to file
      echo "${ret[ctx]}" > "${ctxdata}"

      declare -p ret

      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0

      ;;

    "#NBinaryOp")
      local left="${atom[left]}"
      echo "${left}" > /dev/shm/tabloid_exprs
      eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
      __ctxdata="${ret[ctx]}"
      # variale is named expr
      eval "${ret[val]}"
      left=$expr

      local right="${atom[right]}"
      # variale is named expr
      echo "${right}" > /dev/shm/tabloid_exprs
      eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
      __ctxdata="${ret[ctx]}"
      # variale is named expr
      eval "${ret[val]}"
      right=$expr

      #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp: left: ""$left" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp: op: ""${atom[op]}" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp: right: ""$right" >> /dev/stderr

      #set -x
      case "${atom[op]}" in
        "#TIsActually")
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TIsActually: left: ""$left" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TIsActually: op: ""${atom[op]}" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TIsActually: right: ""$right" >> /dev/stderr
          #echo "env_eval: BinaryOp TIsActually: left: ""$left" >> /dev/stderr
          #echo "env_eval: BinaryOp TIsActually: op: ""${atom[op]}" >> /dev/stderr
          #echo "env_eval: BinaryOp TIsActually: right: ""$right" >> /dev/stderr
          declare expr=$(("$left" == "$right"))
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: return: ""$(declare -p expr)" >> /dev/stderr
          #echo "env_eval: BinaryOp TIsActually: return: ""$(declare -p expr)" >> /dev/stderr

          declare -A ret=(
            [val]="$(declare -p expr)"
            [ctx]="${__ctxdata}"
          )
          declare -p ret

          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TAnd")
          declare expr=$(("$left" && "$right"))

          declare -A ret=(
            [val]="$(declare -p expr)"
            [ctx]="${__ctxdata}"
          )
          declare -p ret

          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TOr")
          declare expr=$(("$left" || "$right"))

          declare -A ret=(
            [val]="$(declare -p expr)"
            [ctx]="${__ctxdata}"
          )
          declare -p ret

          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TPlus")
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: left: ""$left" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: op: ""${atom[op]}" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: right: ""$right" >> /dev/stderr
          #echo "env_eval: BinaryOp TPlus: left: ""$left" >> /dev/stderr
          #echo "env_eval: BinaryOp TPlus: op: ""${atom[op]}" >> /dev/stderr
          #echo "env_eval: BinaryOp TPlus: right: ""$right" >> /dev/stderr
          declare expr=$(("$left" + "$right"))
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: return: ""$(declare -p expr)" >> /dev/stderr
          #echo "env_eval: BinaryOp TPlus: return: ""$(declare -p expr)" >> /dev/stderr

          declare -A ret=(
            [val]="$(declare -p expr)"
            [ctx]="${__ctxdata}"
          )
          declare -p ret

          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TMinus")
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TMinus: left: ""$left" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TMinus: op: ""${atom[op]}" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TMinus: right: ""$right" >> /dev/stderr
          declare expr=$(("$left" - "$right"))
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: return: ""$(declare -p expr)" >> /dev/stderr

          declare -A ret=(
            [val]="$(declare -p expr)"
            [ctx]="${__ctxdata}"
          )
          declare -p ret

          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TTimes")
          declare expr=$(("$left" * "$right"))

          declare -A ret=(
            [val]="$(declare -p expr)"
            [ctx]="${__ctxdata}"
          )
          declare -p ret

          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TDividedBy")
          declare expr=$(("$left" / "$right"))

          declare -A ret=(
            [val]="$(declare -p expr)"
            [ctx]="${__ctxdata}"
          )
          declare -p ret

          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TModulo")
          declare expr=$(("$left" % "$right"))

          declare -A ret=(
            [val]="$(declare -p expr)"
            [ctx]="${__ctxdata}"
          )
          declare -p ret

          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TBeats")
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TBeats: left: ""$left" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TBeats: op: ""${atom[op]}" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TBeats: right: ""$right" >> /dev/stderr
          declare expr=$(("$left" > "$right"))
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: return: ""$(declare -p expr)" >> /dev/stderr

          declare -A ret=(
            [val]="$(declare -p expr)"
            [ctx]="${__ctxdata}"
          )
          declare -p ret

          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TSmallerThan")
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TSmallerThan: left: ""$left" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TSmallerThan: op: ""${atom[op]}" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TSmallerThan: right: ""$right" >> /dev/stderr
          declare expr=$(("$left" < "$right"))
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: return: ""$(declare -p expr)" >> /dev/stderr

          declare -A ret=(
            [val]="$(declare -p expr)"
            [ctx]="${__ctxdata}"
          )
          declare -p ret

          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        *)
          #echo "[""$expr_grp_depth""] : ""Runtime error: Unknown binary op ""${atom[op]}" >> /dev/stderr
          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 1
          ;;
      esac

      ;;

    "#NIfExpr")
      local cond="${atom[cond]}"

      #echo "env_eval2: IfExpr: pre eval cond: ""$cond" >> /dev/stderr
      echo "${cond}" > /dev/shm/tabloid_exprs
      eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
      __ctxdata="${ret[ctx]}"
      #echo "env_eval2: IfExpr: cond result: ""${ret[val]}" >> /dev/stderr
      # variable is named expr
      eval "${ret[val]}"

      if [[ "$expr" -gt 0 ]]; then # true condition
        #echo "env_eval2: IfExpr: ifbody: ""${atom[ifbody]}" >> /dev/stderr
        echo "${atom[ifbody]}" > /dev/shm/tabloid_exprs
        unset ret
        eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
        __ctxdata="${ret[ctx]}"

        declare -A ret_copy
        # copy from ret to ret_copy
        for key in "${!ret[@]}";
        do
          ret_copy[$key]="${ret[$key]}"
        done

        unset ret
        declare -A ret=(
          [val]="${ret_copy[val]}"
          [ctx]="${__ctxdata}"
        )
        #echo "env_eval2: IfExpr: ifbody result: ""${ret[val]}" >> /dev/stderr
        declare -p ret

        #expr_grp_depth=$(($expr_grp_depth - 1))
        #dump_debug_context expr_grp_depth
        return 0
      fi
      if [[ -n "${atom[elsebody]}" ]]; then
        #echo "env_eval2: IfExpr: elsebody: ""${atom[elsebody]}" >> /dev/stderr
        echo "${atom[elsebody]}" > /dev/shm/tabloid_exprs
        eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
        __ctxdata="${ret[ctx]}"

        declare -A ret_copy
        # copy from ret to ret_copy
        for key in "${!ret[@]}";
        do
          ret_copy[$key]="${ret[$key]}"
        done

        unset ret
        declare -A ret=(
          [val]="${ret_copy[val]}"
          [ctx]="${__ctxdata}"
        )
        #echo "env_eval2: IfExpr: elsebody result: ""${ret[val]}" >> /dev/stderr
        declare -p ret
      fi

      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NExprGroup")

      #echo "[""$expr_grp_depth""] : ""parser_expr: ExprGroup: expr_grp_depth before: ""${expr_grp_depth}" >> /dev/stderr
      #expr_grp_depth=$(($expr_grp_depth + 1))
      #dump_debug_context expr_grp_depth
      #echo "[""$expr_grp_depth""] : ""parser_expr: ExprGroup: expr_grp_depth after: ""${expr_grp_depth}" >> /dev/stderr
      #if [[ -v $exprs ]]; then
      #if [[ ! -z ${exprs+x} ]]; then
      #if [[ -z ${arr_name+x} ]] || [[ -z ${tmp+x} ]]; then
      #  local arr_name=exprs_$expr_grp_depth
      #  declare -a $arr_name="()"
      #  local tmp=${arr_name}[@]
      #  # copy from expr to expr_copy
      #  for expr in "${exprs[@]}";
      #  do
      #    eval "${tmp:0:-3}+=('$expr')"
      #  done
      #  unset exprs
      #fi

      eval "${atom[exprs]}"
      if [[ "${#exprs[@]}" -eq 0 ]]; then
        #echo "Runtime error: Empty expression group with no expressions" >> /dev/stderr

        #expr_grp_depth=$(($expr_grp_depth - 1))
        #dump_debug_context expr_grp_depth
        return 1
      fi
      #echo "[""$expr_grp_depth""] : ""parser_expr: ExprGroup: nexprs: ""${#exprs[@]}" >> /dev/stderr
      #echo "env_eval2: ExprGroup: nexprs: ""${#exprs[@]}" >> /dev/stderr

      local retval=""
      unset expr
      for expr in "${exprs[@]}";
      do
        #echo "[""$expr_grp_depth""] : ""parser_expr: ExprGroup: pre eval expr: ""$expr" >> /dev/stderr
        #echo "env_eval2: ExprGroup: pre eval expr: ""$expr" >> /dev/stderr
        echo "${expr}" > /dev/shm/tabloid_exprs
        eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
        __ctxdata="${ret[ctx]}"
        retval="${ret[val]}"
        #echo "[""$expr_grp_depth""] : ""parser_expr: ExprGroup: expr: ""$expr" >> /dev/stderr
        #echo "[""$expr_grp_depth""] : ""parser_expr: ExprGroup: rv: ""$rv" >> /dev/stderr
        #echo "env_eval2: ExprGroup: expr: ""$expr" >> /dev/stderr
        #echo "env_eval2: ExprGroup: retval: ""$retval" >> /dev/stderr
      done

      #if [[ -v $exprs_copy ]]; then
      #if [[ ! -z ${arr_name+x} ]] && [[ ! -z ${tmp+x} ]]; then
      #  unset exprs
      #  declare -a exprs=()
      #  # copy from expr_copy to expr
      #  for expr in "${!tmp}";
      #  do
      #    exprs+=("$expr")
      #  done
      #  unset $arr_name
      #  unset arr_name
      #  unset tmp
      #fi
      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_context reader_idx reader_str reader_str_base reader_arr reader_arr_base scopes

      declare -A ret=(
        [val]="${retval}"
        [ctx]="${__ctxdata}"
      )
      declare -p ret

      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NReturnExpr")
      local val="${atom[val]}"
      #local oldval="$val"

      echo "${val}" > /dev/shm/tabloid_exprs
      eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
      __ctxdata="${ret[ctx]}"
      val="${ret[val]}"

      #echo "[""$expr_grp_depth""] : ""env_eval: ReturnExpr: val: ""$oldval" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: ReturnExpr: eval val: ""$val" >> /dev/stderr
      #echo "env_eval2: ReturnExpr: val: ""$oldval" >> /dev/stderr
      #echo "env_eval2: ReturnExpr: eval val: ""$val" >> /dev/stderr

      declare -A ret=(
        [val]="${val}"
        [ctx]="${__ctxdata}"
      )
      declare -p ret

      #echo "[""$expr_grp_depth""] : ""ReturnExpr" >> /dev/stderr

      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NProgEndExpr")
      #echo "[""$expr_grp_depth""] : ""END" >> /dev/stderr

      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NPrintExpr")
      local val="${atom[val]}"
      #echo "[""$expr_grp_depth""] : ""env_eval: PrintExpr: val: ""$val" >> /dev/stderr
      #echo "env_eval: PrintExpr: val: ""$val" >> /dev/stderr

      echo "${val}" > /dev/shm/tabloid_exprs
      eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
      __ctxdata="${ret[ctx]}"
      val="${ret[val]}"
      #echo "[""$expr_grp_depth""] : ""env_eval: PrintExpr: eval val: ""$val" >> /dev/stderr
      #echo "env_eval: PrintExpr: eval val: ""$val" >> /dev/stderr

      eval "$val"
      if [[ "$expr" == "true" ]]; then
        expr="TOTALLY RIGHT"
      elif [[ "$expr" == "false" ]]; then
        expr="COMPLETELY WRONG"
      fi

      # Print to stderr
      echo "$expr" >> /dev/stderr

      declare -A ret=(
        [val]="$(declare -p expr)"
        [ctx]="${__ctxdata}"
      )
      declare -p ret

      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NInputExpr")
      local val="${atom[val]}"

      echo "${val}" > /dev/shm/tabloid_exprs
      eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
      __ctxdata="${ret[ctx]}"
      eval "${ret[val]}"

      if [[ "$expr" == "true" ]]; then
        expr="TOTALLY RIGHT"
      elif [[ "$expr" == "false" ]]; then
        expr="COMPLETELY WRONG"
      fi

      # Print prompt to stderr
      echo "$expr" >> /dev/stderr

      unset expr
      read expr

      declare -A ret=(
        [val]="$(declare -p expr)"
        [ctx]="${__ctxdata}"
      )
      declare -p ret

      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

  esac

  #expr_grp_depth=$(($expr_grp_depth - 1))
  #dump_debug_context expr_grp_depth

}

export -f env_eval2

function env_run2() {
  # variable is named nodes
  #eval "$1"
  eval "$(cat "$1")"

  # load context
  local ctxdata="${ctx}"
  local __ctxdata=""

  local retval=""
  for node in "${nodes[@]}";
  do
    #echo "env_run2: node: ""${node}" > /dev/stderr
    echo "${node}" > /dev/shm/tabloid_exprs
    eval "$(call3 ctxdata env_eval2 "/dev/shm/tabloid_exprs")"
    __ctxdata="${ret[ctx]}"
    retval="${ret[val]}"
  done

  declare -A ret=(
    [val]="${retval}"
    [ctx]="${__ctxdata}"
  )
  declare -p ret

  return 0
}

export -f env_run2

function mytest() {
  result="$(reader_start2 "hello world" "")"
  env ctx="$result" bash -c reader_peek2
}

function reader_start() {
  create_context_store
  #create_debug_context_store

  local reader_idx=0
  local reader_str=""
  local reader_str_base=""
  local reader_arr=()
  local reader_arr_base=()
  declare -g -a scopes=("declare -A scope=()")

  # debug context
  #local expr_grp_depth=0

  if [[ "$1" == "--" ]]; then
    declare -n arrname=$2
    declare -n arrbasename=$3
    reader_arr=("${arrname[@]}")
    reader_arr_base=("${arrbasename[@]}")
  else
    reader_str="$1"
    reader_str_base="$2"
  fi

  dump_context reader_idx reader_str reader_str_base reader_arr reader_arr_base scopes
}

function reader_peek() {
  local ctxdata="$(source_context)"
  #echo $ctxdata
  eval "$ctxdata"

  if [[ "${#reader_arr[@]}" -eq 0 ]]; then
    echo "${reader_str:$reader_idx:1}"
  else
    echo "${reader_arr[$reader_idx]}"
  fi

  #dump_context
  #dump_context reader_idx reader_str reader_str_base reader_arr reader_arr_base
}

function reader_next() {
  local ctxdata="$(source_context)"
  #echo $ctxdata
  eval "$ctxdata"

  local idx=$reader_idx
  reader_idx=$(($reader_idx + 1))
  if [[ "${#reader_arr[@]}" -eq 0 ]]; then
    echo "${reader_str:$idx:1}"
  else
    echo "${reader_arr[$idx]}"
  fi

  #dump_context
  dump_context reader_idx reader_str reader_str_base reader_arr reader_arr_base scopes
}

function reader_has_next() {
  eval "$(source_context)"

  if [[ "${#reader_arr[@]}" -eq 0 ]]; then
    if [[ $reader_idx -lt ${#reader_str} ]]; then
      return 1
    fi
  else
    if [[ $reader_idx -lt ${#reader_arr[@]} ]]; then
      return 1
    fi
  fi

  return 0

  #dump_context
  #dump_context reader_idx reader_str reader_str_base
}

function reader_backstep() {
  eval "$(source_context)"

  reader_idx=$(($reader_idx - 1))

  #dump_context
  dump_context reader_idx reader_str reader_str_base reader_arr reader_arr_base scopes
}

function foo() {
  if [[ "$1" == "" ]] || [[ "$1" == " " ]]; then
    return 0
  else
    return 1
  fi
}

export -f foo

function reader_read_until() {
  eval "$(source_context)"

  local predicate=$1
  if [[ "${#reader_arr[@]}" -eq 0 ]]; then
    local result=$reader_str_base
  else
    local result=("${reader_arr_base[@]}")
  fi

  while ! reader_has_next && $predicate "$(reader_peek)"; # we accept false condition for predicate
  do
    local newresult="$(reader_next)"
    if [[ "${#reader_arr[@]}" -eq 0 ]]; then
      result="$result""$newresult"
    else
      result+=("$newresult")
    fi
  done
  
  if [[ "${#reader_arr[@]}" -eq 0 ]]; then
    echo "$result"
  else
    echo "${result[@]}"
  fi
}

function reader_drop_whitespace() {
  function skip_ws() {
    if [[ -z "$1" || "${1:0:1}" == " " ]]; then
      return 0 # false case, ws found
    else
      return 1 # true case, non-ws found
    fi
  }

  reader_read_until skip_ws
}

function reader_expect() {
  local tok="$1"
  local next="$(reader_next)"
  if [[ "$next" != "$tok" ]]; then
    echo "Parsing error: expected ""$tok"", got ""$next" >> /dev/stderr
    return 1
  else
    return 0
  fi
}

function wordifier_start() {
  #echo "wordifier_start: arg: ""$1" >> /dev/stderr
  reader_start "$1" ""
}

function wordifier_wordify() {

  function filter() {
    # return true condition if tok in ('(', ')', ',') or ws
    local tok="$1"
    #tok="$(echo "$tok" | xargs)" # trim
    tok="$(echo "$tok" | tr -d " ")" # trim
    #echo "filter: tok: ""$tok"
    if [[ -z "$tok" ]]; then
      return 1 # true condition, ws found
    fi
    if [[ "$tok" =~ ^[(),] ]]; then
      return 1 # true condition, ('(', ')', ',') found
    fi
    # return false condition
    return 0
  }

  local wordifier_tokens=()

  while ! reader_has_next;
  do
    local next="$(reader_next)"

    #echo "wordify: next: ""$next"
    case $next in
      "(")
        wordifier_tokens+=("(")
        ;;
      ")")
        wordifier_tokens+=(")")
        ;;
      ",")
        wordifier_tokens+=(",")
        ;;
      '"')
        #eval "$(wordifier_wordify_string "$next")"
        #for strtok in ${wordify_string_tokens[@]};
        #do
        #  wordifier_tokens+=("$strtok")
        #done
        wordifier_tokens+=("$(wordifier_wordify_string "$next")")
        ;;
      "'")
        #eval "$(wordifier_wordify_string "$next")"
        #for strtok in ${wordify_string_tokens[@]};
        #do
        #  wordifier_tokens+=("$strtok")
        #done
        wordifier_tokens+=("$(wordifier_wordify_string "$next")")
        ;;
      *)
        # read until ws
        reader_backstep
        local tok="$(reader_read_until filter)"
        #echo "wordify: tok: ""$tok"
        wordifier_tokens+=("$tok")
        ;;
    esac

    reader_drop_whitespace 1>/dev/null
  done

  #echo "${wordifier_tokens[@]}"
  #for tok in ${wordifier_tokens[@]};
  #do
  #  echo "token: ""$tok"
  #done
  declare -p wordifier_tokens
}

function ends_with() {
  local str="$1"
  local nstr=${#str}
  local tofind="$2"
  local ntofind=${#tofind}

  if [[ $ntofind -gt $nstr ]]; then
    return 0 # pattern is longer than string
  fi
  if [[ $ntofind -eq $nstr ]]; then
    if [[ "$str" == "$tofind" ]]; then
      return 1
    else
      return 0
    fi
  fi
  local start=$(($nstr - $ntofind))
  if [[ "${str:$start}" == "$tofind" ]]; then
    return 1
  fi
  return 0
}

export -f ends_with

function starts_with() {
  local str="$1"
  local nstr=${#str}
  local tofind="$2"
  local ntofind=${#tofind}

  if [[ $ntofind -gt $nstr ]]; then
    return 0 # pattern is longer than string
  fi
  if [[ $ntofind -eq $nstr ]]; then
    if [[ "$str" == "$tofind" ]]; then
      return 1
    else
      return 0
    fi
  fi
  if [[ "${str:0:$ntofind}" == "$tofind" ]]; then
    return 1
  fi
  return 0
}

export -f starts_with

function wordifier_wordify_string() {


  local endchar="$1"

  function filter() {
    if [[ "$1" == "$endchar" ]]; then
      return 1
    else
      return 0
    fi
  }

  local accum=""
  accum="$accum""$(reader_read_until filter)"

  #echo "wordify_string: 1accum: ""$accum"
  while ! ends_with "$accum" "\\" && ! reader_has_next;
  do
    accum="${accum:0:-1}"
    #echo "wordify_string: 2accum: ""$accum"
    reader_next 1>/dev/null # end char
    call2 
    accum="$accum""$endchar""$(reader_read_until filter)"
    #echo "wordify_string: 3accum: ""$accum"
  done

  reader_next 1>/dev/null # throw away closing char

  #echo "wordify_string: 4accum: ""$accum"
  #local wordify_string_tokens=('"'"$accum")
  #declare -p wordify_string_tokens
  echo '"'"$accum"
}

function tokenize() {
  #echo "tokenize: arg: ""$1" >> /dev/stderr
  local prog="$1"
  
  wordifier_start "$prog"

  eval "$(wordifier_wordify)"

  base=()
  reader_start -- wordifier_tokens base

  local tokens=()

  while ! reader_has_next;
  do
    local next="$(reader_next)"

    case "$next" in
      "DISCOVER")
        reader_expect "HOW"
        reader_expect "TO"
        tokens+=(${T[DiscoverHowTo]})
        ;;
      "WITH")
        tokens+=(${T[With]})
        ;;
      "OF")
        tokens+=(${T[Of]})
        ;;
      "RUMOR")
        reader_expect "HAS"
        reader_expect "IT"
        tokens+=(${T[RumorHasIt]})
        ;;
      "WHAT")
        reader_expect "IF"
        tokens+=(${T[WhatIf]})
        ;;
      "LIES!")
        tokens+=(${T[LiesBang]})
        ;;
      "END")
        reader_expect "OF"
        reader_expect "STORY"
        tokens+=(${T[EndOfStory]})
        ;;
      "EXPERTS")
        reader_expect "CLAIM"
        tokens+=(${T[ExpertsClaim]})
        ;;
      "TO")
        reader_expect "BE"
        tokens+=(${T[ToBe]})
        ;;
      "YOU")
        reader_expect "WON'T"
        reader_expect "WANT"
        reader_expect "TO"
        reader_expect "MISS"
        tokens+=(${T[YouWontWantToMiss]})
        ;;
      "LATEST")
        reader_expect "NEWS"
        reader_expect "ON"
        tokens+=(${T[LatestNewsOn]})
        ;;
      "IS")
        reader_expect "ACTUALLY"
        tokens+=(${T[IsActually]})
        ;;
      "AND")
        tokens+=(${T[And]})
        ;;
      "OR")
        tokens+=(${T[Or]})
        ;;
      "PLUS")
        tokens+=(${T[Plus]})
        ;;
      "MINUS")
        tokens+=(${T[Minus]})
        ;;
      "TIMES")
        tokens+=(${T[Times]})
        ;;
      "DIVIDED")
        reader_expect "BY"
        tokens+=(${T[DividedBy]})
        ;;
      "MODULO")
        tokens+=(${T[Modulo]})
        ;;
      "BEATS")
        tokens+=(${T[Beats]})
        ;;
      "SMALLER")
        reader_expect "THAN"
        tokens+=(${T[SmallerThan]})
        ;;
      "SHOCKING")
        reader_expect "DEVELOPMENT"
        tokens+=(${T[ShockingDevelopment]})
        ;;
      "PLEASE")
        reader_expect "LIKE"
        reader_expect "AND"
        reader_expect "SUBSCRIBE"
        tokens+=(${T[PleaseLikeAndSubscribe]})
        ;;
      "TOTALLY")
        reader_expect "RIGHT"
        tokens+=(${T[TotallyRight]})
        ;;
      "COMPLETELY")
        reader_expect "WRONG"
        tokens+=(${T[CompletelyWrong]})
        ;;
        "(")
        tokens+=(${T[LParen]})
        ;;
      ")")
        tokens+=(${T[RParen]})
        ;;
      ",")
        tokens+=(${T[Comma]})
        ;;
      *)
        tokens+=("$next")
        #if [[ $next =~ ^-?[0-9]+$ ]]; then
        #  tokens+=("$next}")
        #fi
        ;;
          
    esac

  done

  declare -p tokens
}

# Atom
#  Ident
#  NumberLiteral
#  StringLiteral
#  BoolLiteral
#  FnCall
#  FnDecl
#  ExprGroup
#
# Expression:
#  (begins with atom)
#      BinaryOp
#      Atom
#  (begins with keyword)
#      IfExpr
#      Assignment
#      ReturnExpr
#      ProgEndExpr
#      PrintExpr
#      InputExpr

function parser_start() {
  #declare -n tokenarrname="$1"
  #local tokens=("${tokenarrname[@]}")
  local tokenarrname=$1[@]
  local tokens=("${!tokenarrname}")
  local base=()

  reader_start -- tokens base
}

function parser_parse() {
  declare -g -a nodes=()

  while ! reader_has_next;
  do
    nodes+=("$(parser_expr)")
  done

  #if [[ ! ${nodes[$((${#nodes[@]} - 1))]} == ${N[ProgEndExpr]} ]]; then
  # get last node
  eval "${nodes[-1]}"
  if [[ ! "${expr[type]}" == "${N[ProgEndExpr]}" ]]; then
    echo "Parsing error: A Tabloid program MUST end with PLEASE LIKE AND SUBSCRIBE" >> /dev/stderr
  fi

  declare -p nodes
}

function parser_expect_ident_string() {
  local ident="$(reader_next)"
  if [[ ! "$ident" =~ ^-?[0-9]+$ ]] && starts_with "$ident" '"'; then
    echo "$ident"
    return 0
  fi
  echo "Parsing error: expected identifier, got" >> /dev/stderr
  #echo "Parsing error: expected identifier, got ""${ident.toString()}`);
  return 1
}

function parser_atom() {
  local next="$(reader_next)"

  if [[ "$next" == "${T[TotallyRight]}" ]]; then
    declare -A expr=(
      [type]="${N[BoolLiteral]}"
      [val]="true" # true
    )
    declare -p expr
    return 0

  elif [[ "$next" == "${T[CompletelyWrong]}" ]]; then
    declare -A expr=(
      [type]="${N[BoolLiteral]}"
      [val]="false" # false
    )
    declare -p expr
    return 0

  elif [[ "$next" == "${T[DiscoverHowTo]}" ]]; then
    # function literal
    local fnname="$(reader_next)"

    if [[ "$(reader_peek)" == "${T[With]}" ]]; then
      reader_next 1>/dev/null # with

      # with args
      local args=("$(parser_expect_ident_string)")

      while [[ "$(reader_peek)" == "${T[Comma]}" ]];
      do
        reader_next 1>/dev/null # comma
        args+=("$(parser_expect_ident_string)")
      done

      eval "$(parser_expr)"
      declare -A ret=(
        [type]="${N[FnDecl]}"
        [name]="$fnname"
        [args]="$(declare -p args)"
        [body]="$(declare -p expr)"
      )
      unset expr
      declare -A expr
      # copy from ret to expr
      for key in "${!ret[@]}";
      do
        expr[$key]="${ret[$key]}"
      done
      declare -p expr
      return 0
    fi
    # TODO else part

  elif [[ "$next" == "${T[RumorHasIt]}" ]]; then
    unset exprs
    declare -a exprs=()
    while ! reader_has_next && [[ ! "$(reader_peek)" == "${T[EndOfStory]}" ]];
    do
      exprs+=("$(parser_expr)")
    done
    reader_expect "${T[EndOfStory]}"

    declare -A expr=(
      [type]="${N[ExprGroup]}"
      [exprs]="$(declare -p exprs)"
    )
    declare -p expr
    return 0

  elif [[ "$next" == "${T[LParen]}" ]]; then
    unset exprs
    declare -a exprs=()
    while ! reader_has_next && [[ ! "$(reader_peek)" == "${T[RParen]}" ]];
    do
      exprs+=("$(parser_expr)")
    done
    reader_expect "${T[RParen]}"

    declare -A expr=(
      [type]="${N[ExprGroup]}"
      [exprs]="$(declare -p exprs)"
    )
    declare -p expr
    return 0

  elif [[ "$next" =~ ^-?[0-9]+$ ]]; then
    # number
    unset expr
    declare -A expr=(
      [type]="${N[NumberLiteral]}"
      [val]="$next"
    )
    declare -p expr
    return 0

  elif [[ ! "$next" =~ ^-?[0-9]+$ ]]; then
    # string
    if ! starts_with "$next" '"'; then
      declare -A expr=(
        [type]="${N[StringLiteral]}"
        [val]="${next:1}"
      )
      declare -p expr
      return 0

    fi

    unset expr
    declare -A expr=(
      [type]="${N[Ident]}"
      [val]="$next"
    )

    if [[ "$(reader_peek)" == "${T[Of]}" ]]; then
      echo "$(parser_fncall "$(declare -p expr)")"
      return 0
    fi

    declare -p expr
    return 0

  else
    #"echo "Parsing error: expected ident, literal, or block, got ${
    #        next.toString()
    #    } before ${this.tokens.peek().toString()});
    echo "Parsing error: expected ident, literal, or block, got ${next}" >> /dev/stderr

    return 1
  fi
}

function array_contains () {
  local seeking=$1; shift
  local in=0
  for element; do
    if [[ "$element" == "$seeking" ]]; then
      in=1
      break
    fi
  done
  return $in
}

export -f array_contains

function parser_expr() {
  local next="$(reader_next)"

  if [[ "$next" == "${T[WhatIf]}" ]]; then
    # if expr
    local cond="$(parser_expr)"
    local ifbody="$(parser_expr)"

    local elsebody=""
    if [[ "$(reader_peek)" == "${T[LiesBang]}" ]]; then
      reader_next 1>/dev/null # LiesBang
      elsebody="$(parser_expr)"
    fi
    declare -A expr=(
      [type]="${N[IfExpr]}"
      [cond]="$cond"
      [ifbody]="$ifbody"
      [elsebody]="$elsebody"
    )
    declare -p expr
    return 0

  elif [[ "$next" == "${T[ExpertsClaim]}" ]]; then
    # assignment
    local name="$(parser_expect_ident_string)"
    reader_expect "${T[ToBe]}"
    local val="$(parser_expr)"
    #echo "parser_expr: ExpertsClaim: name: ""$name" >> /dev/stderr
    #echo "parser_expr: ExpertsClaim: val: ""$val" >> /dev/stderr
    declare -A ret=(
        [type]="${N[Assignment]}"
        [name]="$name"
        [val]="$val"
    )
    unset expr
    declare -A expr
    # copy from ret to expr
    for key in "${!ret[@]}";
    do
      expr[$key]="${ret[$key]}"
    done
    declare -p expr
    return 0

  elif [[ "$next" == "${T[ShockingDevelopment]}" ]]; then
    # return
    local val="$(parser_expr)"
#echo "parser_expr: ShockingDevelopment: val: ""$val" >> /dev/stderr
    unset expr
    declare -A expr=(
        [type]="${N[ReturnExpr]}"
        [val]="$val"
    )
    #declare -A expr
    ## copy from ret to expr
    #for key in "${!ret[@]}";
    #do
    #  expr[$key]="${ret[$key]}"
    #done
    declare -p expr
    return 0

  elif [[ "$next" == "${T[PleaseLikeAndSubscribe]}" ]]; then
    # prog end
    declare -A expr=(
        [type]="${N[ProgEndExpr]}"
    )
    declare -p expr
    return 0

  elif [[ "$next" == "${T[YouWontWantToMiss]}" ]]; then
    # print expr
    local val="$(parser_expr)"
    declare -A expr=(
      [type]="${N[PrintExpr]}"
      [val]="$val"
    )
    #unset expr
    #declare -A expr
    ## copy from ret to expr
    #for key in "${!ret[@]}";
    #do
    #  expr[$key]="${ret[$key]}"
    #done
    declare -p expr
    return 0

  elif [[ "$next" == "${T[LatestNewsOn]}" ]]; then
    # input expr
    local val="$(parser_expr)"
    declare -A expr=(
        [type]="${N[InputExpr]}"
        [val]="$val"
    )
    declare -p expr
    return 0
  
  fi

  reader_backstep
  eval "$(parser_atom)"

  if ! array_contains "$(reader_peek)" "${BINARY_OPS[@]}"; then
    declare -A ret=(
        [type]="${N[BinaryOp]}"
        [op]=""
        [left]=""
        [right]=""
    )

    # infix binary ops
    ret[left]="$(declare -p expr)"
    #echo "parser_expr: Binary op found: left: ""${ret[left]}" >> /dev/stderr

    local op="$(reader_next)"
    #echo "parser_expr: Binary op found: op: ""$op" >> /dev/stderr

    ret[op]="$op"

    unset expr
    eval "$(parser_atom)"
    ret[right]="$(declare -p expr)"
    #echo "parser_expr: Binary op found: right: ""${ret[right]}" >> /dev/stderr
    
    unset expr
    declare -A expr
    for key in "${!ret[@]}"; do
      expr[$key]="${ret[$key]}"
    done
    declare -p expr
    return 0

  fi

  declare -A expr
  for key in "${!atom[@]}"; do
    expr[$key]=${atom[$key]}
  done

  declare -p expr
}

function parser_fncall() {
  # variable is name expr
  eval "$1"

  # make copy of expr
  declare -A expr_copy=()
  for expr_key in "${!expr[@]}";
  do
    expr_copy[$expr_key]="${expr[$expr_key]}"
  done

  reader_expect "${T[Of]}"

  unset expr
  # variable is name expr
  eval "$(parser_expr)"

  local args=("$(declare -p expr)")

  while [[ "$(reader_peek)" == "${T[Comma]}" ]];
  do
    reader_next 1>/dev/null # comma

    eval "$(parser_expr)"
    args+=("$(declare -p expr)")
  done

  unset expr
  declare -A expr=()
  # copy back
  for expr_key in "${!expr_copy[@]}";
  do
    expr[$expr_key]="${expr_copy[$expr_key]}"
  done

  declare -A ret=(
    [type]="${N[FnCall]}"
    [fn]="$(declare -p expr)"
    [args]="$(declare -p args)"
  )
  # copy back
  for ret_key in "${!ret[@]}";
  do
    expr[$ret_key]="${ret[$ret_key]}"
  done
  declare -p expr
  return 0
}

function env_eval() {
  # variable name is expr
  unset expr
  eval "$1"
  unset atom
  declare -A atom
  # copy from expr to atom
  for key in "${!expr[@]}";
  do
    atom[$key]="${expr[$key]}"
  done

  eval "$(source_context)"
  #eval "$(source_debug_context)"

  #expr_grp_depth=$(($expr_grp_depth + 1))
  #dump_debug_context expr_grp_depth

  unset scope
  unset scope_idx
  # scopes array contains each scope as declare -p scope
  if [[ "${#scopes[@]}" -gt 0 ]]; then
    eval "${scopes[-1]}"
    local scope_idx=$((${#scopes[@]} - 1))
  else
    local scope=()
    local scope_idx=0
  fi

  unset expr

  case "${atom[type]}" in
    "#NNumberLiteral")
      ;&
    "#NStringLiteral")
      ;&
    "#NBoolLiteral")
      declare expr="${atom[val]}"
      declare -p expr
      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NFnDecl")
      #eval "$(source_context)"

      # scopes array contains each scope as declare -p scope
      #if [[ ${#scopes[@]} -gt 0 ]]; then
      #  eval "${scopes[-1]}"
      #  local scope_idx=$((${#scopes[@]} - 1))
      #else
      #  local scope=()
      #  local scope_idx=0
      #fi

      declare -A expr=()
      # copy from atom to expr
      for key in "${!atom[@]}";
      do
        expr[$key]="${atom[$key]}"
      done

      scope["${atom[name]}"]="$(declare -p expr)"
      scopes[$scope_idx]="$(declare -p scope)"
      dump_context reader_idx reader_str reader_str_base reader_arr reader_arr_base scopes
      declare -p expr
      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NFnCall")
      #eval "$(source_context)"

      local fn="${atom[fn]}"
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: fn: ""$fn" >> /dev/stderr
      # variale is named expr
      fn="$(env_eval "$fn")"
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: eval fn: ""$fn" >> /dev/stderr

      # map eval to atom[args]
      # variable is named args
      eval "${atom[args]}"
      declare -a args_copy=()
      for key in "${!args[@]}";
      do
        local arg="${args[$key]}"

        unset expr
        # variale is named expr
        local result="$(env_eval "$arg")"
        #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: result: ""$result" >> /dev/stderr
        # make copy of args
        args_copy[$key]="$(echo "$result")"
      done

      unset scope
      declare -A scope=()
      # TODO do this for function args not fn call args
      #unset args
      # variable is named expr
      eval "$fn"
      # variable is named args
      eval "${expr[args]}"
      # this args corresponds to function argument identifiers literals
      # args_copy contains actual evaluated argument values
      for key in "${!args[@]}";
      do
        scope[${args[$key]}]="${args_copy[$key]}"
      done

      scopes+=("$(declare -p scope)")
      dump_context reader_idx reader_str reader_str_base reader_arr reader_arr_base scopes

      local fnbody="${expr[body]}"
      unset expr
      local fnresult="$(env_eval "$fnbody")"
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: fnname: ""${atom[val]}" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: fnargs: ""${args[@]}" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: args: ""${args_copy[@]}" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: fnresult: ""$fnresult" >> /dev/stderr
      #eval "$fnresult"
      #echo "[""$expr_grp_depth""] : ""env_eval: FnCall: eval fnresult: ""$fnresult" >> /dev/stderr

      # pop latest scope
      #unset scopes
      #eval "$(source_context)"
      unset scopes[-1]
      dump_context reader_idx reader_str reader_str_base reader_arr reader_arr_base scopes
      #echo END
      echo "$fnresult"
      #declare -p expr
      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NIdent")
      #eval "$(source_context)"

      #echo "[""$expr_grp_depth""] : ""env_eval: NIdent: val: ""${atom[val]}" >> /dev/stderr

      local i=$((${#scopes[@]} - 1))
      while [[ $i -ge 0 ]];
      do
          #echo "[""$expr_grp_depth""] : ""env_eval: NIdent: val: ""${atom[val]}" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: NIdent: current scope: ""${scopes[$i]}" >> /dev/stderr
          unset scope
          #echo "[""$expr_grp_depth""] : ""env_eval: NIdent: current scope : ""${scopes[$i]}" >> /dev/stderr
          eval "${scopes[$i]}"
          #echo "[""$expr_grp_depth""] : ""env_eval: NIdent: current scope keys: ""${!scope[@]}" >> /dev/stderr
          if ! array_contains "${atom[val]}" "${!scope[@]}"; then
            #echo "[""$expr_grp_depth""] : ""env_eval: NIdent: scope: ""${scope[${atom[val]}]}" >> /dev/stderr
            echo "${scope[${atom[val]}]}"
            #expr_grp_depth=$(($expr_grp_depth - 1))
            #dump_debug_context expr_grp_depth
            return 0
          fi
          i=$(($i - 1))
      done
      #echo "[""$expr_grp_depth""] : ""Runtime error: Undefined variable ""${atom[val]}" >> /dev/stderr
      ;;

    "#NAssignment")
      #eval "$(source_context)"

      local val="${atom[val]}"
      #echo "[""$expr_grp_depth""] : ""env_eval: NAssignment: val: ""$val" >> /dev/stderr
      # variable is named expr
      val="$(env_eval "$val")"

      scope["${atom[name]}"]="$val"
      scopes[$scope_idx]="$(declare -p scope)"
      dump_context reader_idx reader_str reader_str_base reader_arr reader_arr_base scopes

      echo "$val"
      #declare -p expr
      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0

      ;;

    "#NBinaryOp")
      local left="${atom[left]}"
      # variale is named expr
      eval "$(env_eval "$left")"
      left=$expr
      local right="${atom[right]}"
      # variale is named expr
      eval "$(env_eval "$right")"
      right=$expr

      #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp: left: ""$left" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp: op: ""${atom[op]}" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp: right: ""$right" >> /dev/stderr

      #set -x
      case "${atom[op]}" in
        "#TIsActually")
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TIsActually: left: ""$left" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TIsActually: op: ""${atom[op]}" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TIsActually: right: ""$right" >> /dev/stderr
          declare expr=$(("$left" == "$right"))
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: return: ""$(declare -p expr)" >> /dev/stderr
          declare -p expr
          set +x
          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TAnd")
          declare expr=$(("$left" && "$right"))
          declare -p expr
          set +x
          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TOr")
          declare expr=$(("$left" || "$right"))
          declare -p expr
          set +x
          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TPlus")
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: left: ""$left" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: op: ""${atom[op]}" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: right: ""$right" >> /dev/stderr
          declare expr=$(("$left" + "$right"))
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: return: ""$(declare -p expr)" >> /dev/stderr
          declare -p expr
          set +x
          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TMinus")
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TMinus: left: ""$left" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TMinus: op: ""${atom[op]}" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TMinus: right: ""$right" >> /dev/stderr
          declare expr=$(("$left" - "$right"))
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: return: ""$(declare -p expr)" >> /dev/stderr
          declare -p expr
          set +x
          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TTimes")
          declare expr=$(("$left" * "$right"))
          declare -p expr
          set +x
          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TDividedBy")
          declare expr=$(("$left" / "$right"))
          declare -p expr
          set +x
          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TModulo")
          declare expr=$(("$left" % "$right"))
          declare -p expr
          set +x
          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TBeats")
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TBeats: left: ""$left" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TBeats: op: ""${atom[op]}" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TBeats: right: ""$right" >> /dev/stderr
          declare expr=$(("$left" > "$right"))
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: return: ""$(declare -p expr)" >> /dev/stderr
          declare -p expr
          set +x
          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        "#TSmallerThan")
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TSmallerThan: left: ""$left" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TSmallerThan: op: ""${atom[op]}" >> /dev/stderr
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TSmallerThan: right: ""$right" >> /dev/stderr
          declare expr=$(("$left" < "$right"))
          #echo "[""$expr_grp_depth""] : ""env_eval: BinaryOp TPlus: return: ""$(declare -p expr)" >> /dev/stderr
          declare -p expr
          set +x
          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 0
          ;;

        *)
          #echo "[""$expr_grp_depth""] : ""Runtime error: Unknown binary op ""${atom[op]}" >> /dev/stderr
          set +x
          #expr_grp_depth=$(($expr_grp_depth - 1))
          #dump_debug_context expr_grp_depth
          return 1
          ;;
      esac

      ;;

    "#NIfExpr")
      local cond="${atom[cond]}"
      eval "$(env_eval "$cond")" 
      if [[ "$expr" -gt 0 ]]; then # true condition
        echo "$(env_eval "${atom[ifbody]}")"
        #expr_grp_depth=$(($expr_grp_depth - 1))
        #dump_debug_context expr_grp_depth
        return 0
      fi
      if [[ -n "${atom[elsebody]}" ]]; then
        echo "$(env_eval "${atom[elsebody]}")"
      fi
      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NExprGroup")

      #echo "[""$expr_grp_depth""] : ""parser_expr: ExprGroup: expr_grp_depth before: ""${expr_grp_depth}" >> /dev/stderr
      #expr_grp_depth=$(($expr_grp_depth + 1))
      #dump_debug_context expr_grp_depth
      #echo "[""$expr_grp_depth""] : ""parser_expr: ExprGroup: expr_grp_depth after: ""${expr_grp_depth}" >> /dev/stderr
      #if [[ -v $exprs ]]; then
      #if [[ ! -z ${exprs+x} ]]; then
      #if [[ -z ${arr_name+x} ]] || [[ -z ${tmp+x} ]]; then
      #  local arr_name=exprs_$expr_grp_depth
      #  declare -a $arr_name="()"
      #  local tmp=${arr_name}[@]
      #  # copy from expr to expr_copy
      #  for expr in "${exprs[@]}";
      #  do
      #    eval "${tmp:0:-3}+=('$expr')"
      #  done
      #  unset exprs
      #fi

      eval "${atom[exprs]}"
      if [[ "${#exprs[@]}" -eq 0 ]]; then
        #echo "Runtime error: Empty expression group with no expressions" >> /dev/stderr
        #expr_grp_depth=$(($expr_grp_depth - 1))
        #dump_debug_context expr_grp_depth
        return 1
      fi

      #echo "[""$expr_grp_depth""] : ""parser_expr: ExprGroup: nexprs: ""${#exprs[@]}" >> /dev/stderr
      local rv=""
      unset expr
      for expr in "${exprs[@]}";
      do
        #echo "[""$expr_grp_depth""] : ""parser_expr: ExprGroup: pre eval expr: ""$expr" >> /dev/stderr
        rv="$(env_eval "$expr")"
        #echo "[""$expr_grp_depth""] : ""parser_expr: ExprGroup: expr: ""$expr" >> /dev/stderr
        #echo "[""$expr_grp_depth""] : ""parser_expr: ExprGroup: rv: ""$rv" >> /dev/stderr
      done
      #unset expr
      #expr="$rv"
      #declare -p expr

      #if [[ -v $exprs_copy ]]; then
      #if [[ ! -z ${arr_name+x} ]] && [[ ! -z ${tmp+x} ]]; then
      #  unset exprs
      #  declare -a exprs=()
      #  # copy from expr_copy to expr
      #  for expr in "${!tmp}";
      #  do
      #    exprs+=("$expr")
      #  done
      #  unset $arr_name
      #  unset arr_name
      #  unset tmp
      #fi
      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_context reader_idx reader_str reader_str_base reader_arr reader_arr_base scopes

      echo "$rv"
      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NReturnExpr")
      local val="${atom[val]}"
      local oldval="$val"
      val="$(env_eval "$val")" 
      #echo "[""$expr_grp_depth""] : ""env_eval: ReturnExpr: val: ""$oldval" >> /dev/stderr
      #echo "[""$expr_grp_depth""] : ""env_eval: ReturnExpr: eval val: ""$val" >> /dev/stderr
      echo "$val"
      #echo "[""$expr_grp_depth""] : ""ReturnExpr" >> /dev/stderr
      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NProgEndExpr")
      #echo "[""$expr_grp_depth""] : ""END" >> /dev/stderr
      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NPrintExpr")
      local val="${atom[val]}"
      #echo "[""$expr_grp_depth""] : ""env_eval: PrintExpr: val: ""$val" >> /dev/stderr
      val="$(env_eval "$val")"
      #echo "[""$expr_grp_depth""] : ""env_eval: PrintExpr: eval val: ""$val" >> /dev/stderr
      eval "$val"
      if [[ "$expr" == "true" ]]; then
        expr="TOTALLY RIGHT"
      elif [[ "$expr" == "false" ]]; then
        expr="COMPLETELY WRONG"
      fi
      echo "$expr" >> /dev/stderr
      declare -p expr
      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

    "#NInputExpr")
      local val="${atom[val]}"
      eval "$(env_eval "$val")"
      if [[ "$expr" == "true" ]]; then
        expr="TOTALLY RIGHT"
      elif [[ "$expr" == "false" ]]; then
        expr="COMPLETELY WRONG"
      fi
      echo "$expr" >> /dev/stderr
      unset expr
      read expr
      declare -p expr
      #expr_grp_depth=$(($expr_grp_depth - 1))
      #dump_debug_context expr_grp_depth
      return 0
      ;;

  esac

  #expr_grp_depth=$(($expr_grp_depth - 1))
  #dump_debug_context expr_grp_depth

}

function env_run() {
  # variable is named nodes
  eval "$1"

  local rv=""
  for node in "${nodes[@]}";
  do
    rv="$(env_eval "$node")"
  done
  echo "$rv"
  return 0
}


function op_and() {
  # not numbers
  if [[ ! "$1" =~ ^-?[0-9]+$ || ! "$2" =~ ^-?[0-9]+$ ]]; then
    return 0
  fi

  if [[ $1 -eq 0 || $2 -eq 0 ]]; then
    return 0
  fi

  return 1
}

function op_or() {
  # not numbers
  if [[ ! "$1" =~ ^-?[0-9]+$ || ! "$2" =~ ^-?[0-9]+$ ]]; then
    return 0
  fi

  if [[ $1 -gt 0 || $2 -gt 0 ]]; then
    return 1
  fi

  return 0
}
