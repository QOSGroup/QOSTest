# QOSTest
QOS测试平台

使用说明:
1. 将本项目clone到测试网所有机器的本地主文件夹`~/`下, 成为`~/qos`
2. 将待测试版本的qosd和qoscli可执行文件放到`bin`目录下(`~/qos/bin`)
3. 修改测试网配置文件`~/qos/testnet/config.sh`
4. 调用脚本`~/qos/testnet_init.sh`初始化部署并启动所有测试网节点, 此时`~/qos/bin`目录下的可执行文件会通过scp上传到测试网所有机器, 初始化genesis文件, 并启动所有机器的qosd服务.
5. 调用脚本`~/qos/test.sh`开始测试. 可以修改脚本内容决定发起测试类型.

注意:
1. 要修改genesis文件的生成规则, 请修改`~/qos/init`目录下的`~/qos/init/init_master.sh`和`~/qos/init/init_slave.sh`
2. `~/qos/cert`目录下保存的是QSC和QCP所使用的证书
3. 监控项的定制: 可以在目录`~/qos/test/metrics/`下添加新监控项目, 控制入口在`~/qos/test/metrics.sh`
4. 随机测试在目录`~/qos/test/random_test/`下, 流程测试在目录`~/qos/test/batch_test/`下
5. 可以通过在目录`~/qos/test/batch_test/`下新增.txt文件, 实现定制测试流程

