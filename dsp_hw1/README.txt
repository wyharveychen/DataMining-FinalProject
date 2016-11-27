====== �ɮ׻��� ======

+- dsp_hw1/
   +-  c_cpp/
   |     +-                    �@�� file I/O �����U�{��
   +-  modellist.txt           �n�T�m��model�C��
   +-  model_init.txt          �i�ΰ���l�� HMM
   +-  seq_model_01~05.txt     training data observation
   +-  testing_data1.txt       testing data  observation
   +-  testing_answer.txt      answer for "testing_data1.txt"
   +-  testing_data2.txt       testing data without answer

====== �{������d�� ======

c/cpp:
 make
 ./train $iter model_init.txt seq_model_01.txt model_01.txt
 ./train $iter model_init.txt seq_model_02.txt model_02.txt
 ./train $iter model_init.txt seq_model_03.txt model_03.txt
 ./train $iter model_init.txt seq_model_04.txt model_04.txt
 ./train $iter model_init.txt seq_model_05.txt model_05.txt
 ./test modellist.txt testing_data1.txt result1.txt
 ./test modellist.txt testing_data2.txt result2.txt

�䤤 $iter ���@����ơA�N�� Baum-Welch algorithm �n�]�X�� iteration

====== ú�满�� ======

  1. �Ҧ��A�g���{���ɮ�  ( train.c, test.c, etc. or trainModel.m, testModel.m, etc. )
  2. �V�m�X�Ӫ� HMM:    model_01.txt ~ model_05.txt
  3. result1.txt , result2.txt
  4. acc.txt : The accuracy of testing_data.txt
  5. Document ( �е����Ǹ��m�W, �{������覡, ����, iteration�Ȫ��]�w, �H�Τ@�Ǥ߱o )
  

 ��  �W�Ǩ�ceiba�@�~��  �� 
     ���Y�ɮ� hw1_[�Ǹ�].zip : �`�N! �Х�zip���]�W��!!!
     �п�ӥH�U���](�`�N�n����Ƨ��A�H�θ�Ƨ��W��)�G

     hw1_[�Ǹ�].zip
     +- hw1_[�Ǹ�]/
        +- train.c/.cpp
        +- test.c/.cpp
        +- Makefile
        +- model_01~05.txt
        +- result1~2.txt 
        +- acc.txt
        +- Document.pdf (pdf )