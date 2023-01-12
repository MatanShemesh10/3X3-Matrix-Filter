
#define SLEEP_TIME 5
#define SHORT_SLEEP_TIME 5
#define LEDS_BASE_ADDR 0x010
#define LEDS LEDS_BASE_ADDR 
#define SEVSEG (LEDS_BASE_ADDR +4)

#define ACCEL_BASE 0x020
#define ACCEL_CTRL ACCEL_BASE 
#define ACCEL_PERF_COUNTER (ACCEL_BASE + 0x4)
#define ACCEL_A0 (ACCEL_BASE + 0x8)
#define ACCEL_A1 (ACCEL_BASE + 0xc)
#define ACCEL_A2 (ACCEL_BASE + 0x10)
#define ACCEL_B0 (ACCEL_BASE + 0x14)
#define ACCEL_B1 (ACCEL_BASE + 0x18)
#define ACCEL_B2 (ACCEL_BASE + 0x1c)
#define ACCEL_B3 (ACCEL_BASE + 0x20)
#define ACCEL_C (ACCEL_BASE + 0x24)
#define ACCEL_C2 (ACCEL_BASE + 0x28)

#define PRINT(i, j) *((int *)(i)) = (j)
#define STOP while(1)


int main(){
	int i = 0;
	int* leds = (int*)0x14;
	int* accel_ctrl_ptr = (int *)ACCEL_CTRL;
	int* accel_perf_ctr = (int *)ACCEL_PERF_COUNTER;
	int* accel_data_a0_ptr = (int *)ACCEL_A0;
	int* accel_data_a1_ptr = (int*)ACCEL_A1;
	int* accel_data_a2_ptr = (int*)ACCEL_A2;
	int* accel_data_b0_ptr = (int *)ACCEL_B0;
	int* accel_data_b1_ptr = (int*)ACCEL_B1;
	int* accel_data_b2_ptr = (int*)ACCEL_B2;
	int* accel_data_b3_ptr = (int*)ACCEL_B3;
	int* accel_data_c_ptr = (int *)ACCEL_C;
	int* accel_data_c2_ptr = (int *)ACCEL_C2;

	*accel_data_a0_ptr = 0x00020708;
	*accel_data_a1_ptr = 0x00010203;
	*accel_data_a2_ptr = 0x00050A07;
	*accel_data_b0_ptr = 0x01000203;
	*accel_data_b1_ptr = 0x04000507;
	*accel_data_b2_ptr = 0x0A080201;
	*accel_data_b3_ptr = 0x00050964;
	*accel_ctrl_ptr = 0x00000001; 
	unsigned int saveAns = *accel_data_c_ptr;
	//prints the matrix after dividing in the average
	saveAns = saveAns >> 24; //shift in order to see the A(0,0)
	PRINT(SEVSEG, *accel_data_c_ptr);
	PRINT(SEVSEG, *accel_data_c_ptr);
	PRINT(SEVSEG, *accel_data_c_ptr);
	PRINT(SEVSEG, *accel_data_c_ptr);
	PRINT(SEVSEG, saveAns);
	PRINT(SEVSEG, saveAns);
	PRINT(SEVSEG, saveAns);
	PRINT(SEVSEG, saveAns);
	PRINT(SEVSEG, saveAns);

	//prints the variance
	PRINT(SEVSEG, *accel_data_c2_ptr);
	PRINT(SEVSEG, *accel_data_c2_ptr);
	PRINT(SEVSEG, *accel_data_c2_ptr);
	PRINT(SEVSEG, *accel_data_c2_ptr);
	PRINT(SEVSEG, *accel_data_c2_ptr);
	PRINT(SEVSEG, *accel_data_c2_ptr);
	PRINT(SEVSEG, *accel_data_c2_ptr);
	
	//PRINT(SEVSEG, *accel_perf_ctr);

	while(i<50){
		PRINT(LEDS, i);
		i++;
	}
	STOP;
}
