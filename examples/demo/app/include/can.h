#ifndef _CAN_H
#define _CAN_H

#include <stdbool.h>

#include "main.h"

bool
can_init(CAN_HandleTypeDef *handle);

void
can_send(CAN_HandleTypeDef *handle, uint32_t id, size_t size, uint8_t *msg);

#endif
