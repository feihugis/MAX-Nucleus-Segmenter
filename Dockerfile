#
# Copyright 2018-2019 IBM Corp. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM codait/max-base:v1.1.3

ARG model_bucket=https://max-assets-dev.s3.us-south.cloud-object-storage.appdomain.cloud/max-nucleus-segmenter/1.0
ARG model_file=assets.tar.gz

# Add the missing packages for OpenCV
RUN apt-get update && apt-get install libgtk2.0 -y && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

RUN wget -nv --show-progress --progress=bar:force:noscroll ${model_bucket}/${model_file} --output-document=assets/${model_file} && \
  tar -x -C assets/ -f assets/${model_file} -v && rm assets/${model_file}

COPY requirements.txt /workspace
RUN pip install -r requirements.txt

COPY . /workspace

RUN md5sum -c md5sums.txt # check file integrity

EXPOSE 5000

CMD python app.py
