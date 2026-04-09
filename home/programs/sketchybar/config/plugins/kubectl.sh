#!/bin/sh

# ============ CONFIGURATION ============
# Refresh interval is set in sketchybarrc (update_freq)
# Services to monitor: namespace:service_name
SERVICES="
integration2:order-service
integration2:broker-service
integration2:compliance-service
platform-tools:assay
platform-tools:assay-unstable
"
# ========================================

CACHE_FILE="/tmp/kubectl_status_cache"
KUBECTL="/usr/local/bin/kubectl"

# Check if kubectl exists
if [ ! -x "$KUBECTL" ]; then
  KUBECTL=$(which kubectl 2>/dev/null)
  if [ -z "$KUBECTL" ]; then
    sketchybar --set "$NAME" label="no kubectl"
    exit 0
  fi
fi

# Build the status string
OUTPUT=""

for entry in $SERVICES; do
  [ -z "$entry" ] && continue

  NAMESPACE=$(echo "$entry" | cut -d: -f1)
  SERVICE=$(echo "$entry" | cut -d: -f2)

  # Get pod info using kubectl get pod with jsonpath for efficiency
  POD_INFO=$($KUBECTL get pod -l "app.kubernetes.io/name=$SERVICE" -n "$NAMESPACE" \
    -o jsonpath='{.items[0].status.phase}|{.items[0].status.containerStatuses[0].state}|{.items[0].spec.containers[0].image}' 2>/dev/null)

  if [ -z "$POD_INFO" ]; then
    # Try alternative label
    POD_INFO=$($KUBECTL get pod -l "app=$SERVICE" -n "$NAMESPACE" \
      -o jsonpath='{.items[0].status.phase}|{.items[0].status.containerStatuses[0].state}|{.items[0].spec.containers[0].image}' 2>/dev/null)
  fi

  if [ -z "$POD_INFO" ]; then
    STATUS="?"
    VERSION="?"
  else
    PHASE=$(echo "$POD_INFO" | cut -d'|' -f1)
    STATE_JSON=$(echo "$POD_INFO" | cut -d'|' -f2)
    IMAGE=$(echo "$POD_INFO" | cut -d'|' -f3)

    # Extract version from image (last part after colon)
    VERSION=$(echo "$IMAGE" | sed 's/.*://' | sed 's/^v//')

    # Determine actual status from container state
    if echo "$STATE_JSON" | grep -q '"waiting"'; then
      # Extract waiting reason
      REASON=$(echo "$STATE_JSON" | sed 's/.*"reason":"\([^"]*\)".*/\1/' 2>/dev/null)
      case "$REASON" in
        CrashLoopBackOff) STATUS="Crash" ;;
        ImagePullBackOff) STATUS="ImgErr" ;;
        ErrImagePull) STATUS="ImgErr" ;;
        *) STATUS="Wait" ;;
      esac
    elif echo "$STATE_JSON" | grep -q '"running"'; then
      STATUS="OK"
    elif echo "$STATE_JSON" | grep -q '"terminated"'; then
      STATUS="Term"
    else
      # Fall back to phase
      case "$PHASE" in
        Running) STATUS="OK" ;;
        Pending) STATUS="Pend" ;;
        Succeeded) STATUS="Done" ;;
        Failed) STATUS="Fail" ;;
        *) STATUS="?" ;;
      esac
    fi
  fi

  # Short service name (remove -service suffix if present)
  SHORT_NAME=$(echo "$SERVICE" | sed 's/-service$//' | sed 's/-unstable$/U/')

  # Build entry: service@version-status
  ENTRY="${SHORT_NAME}@${VERSION}-${STATUS}"

  if [ -z "$OUTPUT" ]; then
    OUTPUT="$ENTRY"
  else
    OUTPUT="$OUTPUT | $ENTRY"
  fi
done

# Cache the result
echo "$OUTPUT" > "$CACHE_FILE"

# Set color based on overall status
if echo "$OUTPUT" | grep -qE '(Crash|Fail|ImgErr|Term)'; then
  ICON_COLOR="0xffff5555"  # Red
elif echo "$OUTPUT" | grep -qE '(Wait|Pend|\?)'; then
  ICON_COLOR="0xffffaa55"  # Orange
else
  ICON_COLOR="0xff55ff55"  # Green
fi

sketchybar --set "$NAME" label="$OUTPUT" icon.color="$ICON_COLOR"
