#include <stdint.h>
#include <stdio.h>

#include <wolfssl/wolfcrypt/aes.h>

extern void RunTarget(FILE* input)
{
    uint8_t key[16];
    if(fread(key, 1, 16, input) != 16)
        return;
	
	uint8_t iv[16] = { 0 };
    uint8_t plain[16] = { 0 };
	uint8_t cipher[32];
	
	Aes aes;
	wc_AesSetKey(&aes, key, sizeof(key), iv, AES_ENCRYPTION);
	wc_AesCbcEncrypt(&aes, cipher, plain, sizeof(plain));
	
	//for(int i = 0; i < sizeof(cipher); ++i)
	//	printf("%02x ", cipher[i]);
	//printf("\n");
}

extern void InitTarget(FILE* input)
{
	RunTarget(input);
}