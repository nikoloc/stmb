#include "can.h"

#include <assert.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>

#include "main.h"

volatile bool can_msg_recv = false;
CAN_RxHeaderTypeDef can_header;
uint8_t can_buffer[8] = {0};

void
can_send(CAN_HandleTypeDef *handle, uint32_t id, size_t size, uint8_t *msg) {
    printf("sending message of size %d\n", (int)size);
    if(size > 8) {
        return;
    }

    CAN_TxHeaderTypeDef header = {
            .IDE = CAN_ID_STD,
            .StdId = id,
            .RTR = CAN_RTR_DATA,
            .DLC = size,
    };

    while(HAL_CAN_GetTxMailboxesFreeLevel(handle) == 0) {
        // blank
    }

    uint32_t mailbox;
    if(HAL_CAN_AddTxMessage(handle, &header, msg, &mailbox) == HAL_OK) {
        printf("can message sent\n");
    } else {
        printf("can error\n");
    }
}

void
HAL_CAN_RxFifo0MsgPendingCallback(CAN_HandleTypeDef *handle) {
    if(HAL_CAN_GetRxMessage(handle, CAN_RX_FIFO0, &can_header, can_buffer) == HAL_OK) {
        can_msg_recv = true;
    }
}

bool
can_init(CAN_HandleTypeDef *handle) {
    CAN_FilterTypeDef filter = {
            .FilterBank = 0,
            .FilterMode = CAN_FILTERMODE_IDMASK,
            .FilterScale = CAN_FILTERSCALE_32BIT,
            .FilterIdHigh = 0,
            .FilterIdLow = 0,
            .FilterMaskIdHigh = 0,
            .FilterMaskIdLow = 0,
            .FilterFIFOAssignment = CAN_FILTER_FIFO0,
            .FilterActivation = true,
    };

    if(HAL_CAN_ConfigFilter(handle, &filter) != HAL_OK) {
        printf("config filter failed\n");
        return false;
    }

    if(HAL_CAN_ActivateNotification(handle, CAN_IT_RX_FIFO0_MSG_PENDING) != HAL_OK) {
        printf("activate notification failed\n");
        return false;
    }

    if(HAL_CAN_Start(handle) != HAL_OK) {
        printf("start can failed\n");
        return false;
    }

    return true;
}
