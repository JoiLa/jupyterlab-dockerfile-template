FROM continuumio/anaconda3:latest

MAINTAINER liang <liang@lilogs.com>
# 更新软件源
RUN apt-get update
# 安装软件源

RUN apt-get install wget vim curl -y

# `conda` 更新
RUN conda update -n base -c defaults conda -y
# `jupyter lab` 服务安装
RUN conda install -c conda-forge jupyterlab -y
# 安装`nodejs v12.4.0`
RUN conda install -c conda-forge/label/cf202003 nodejs -y
# 安装`jupyterlab-lsp`编码助手
RUN conda install -c conda-forge 'jupyterlab>=3.0.0,<4.0.0a0' jupyterlab-lsp -y
# 安装`jupyterlab-lsp`服务
RUN pip install 'python-lsp-server[all]'
# `jupyter lab` 安装中文语言包
RUN pip install jupyterlab-language-pack-zh-CN
# 安装`jupyter lab`插件
RUN pip install jupyterlab_code_formatter
# `jupyter lab`扩展安装
# 安装格式化规范
RUN pip install isort black autopep8
# `jupyter lab`扩展服务启动
RUN jupyter serverextension enable --py jupyterlab_code_formatter
# - 格式化代码插件
RUN jupyter labextension install @ryantam626/jupyterlab_code_formatter


# 安装机器学习库
RUN pip install scikit-learn
RUN pip install numpy
RUN pip install scipy
RUN pip install matplotlib
RUN pip install pandas
# 查看 pip list
RUN pip list

# 设置配置信息
RUN echo "==========================================================================="
# 设置`格式化规范`
COPY ./config/settings.jupyterlab-settings  /root/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter/settings.jupyterlab-settings
# 设置`快捷键`快速格式化
COPY ./config/shortcuts.jupyterlab-settings /root/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/shortcuts.jupyterlab-settings
# 设置`jupyter lab`主题为暗黑
COPY ./config/themes.jupyterlab-settings  /root/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings
# 设置`jupyter lab`语言为中文
COPY ./config/plugin.jupyterlab-settings /root/.jupyter/lab/user-settings/@jupyterlab/translation-extension/plugin.jupyterlab-settings
RUN echo "==========================================================================="


# 定义工作环境变量
ENV MYPATH /work
# 设置工作环境变量
WORKDIR $MYPATH

# 启动`jupyter lab` 服务
CMD jupyter lab --ip='*' --port=8888 --no-browser --allow-root --NotebookApp.token=''
# 暴露工作端口
EXPOSE 8888
