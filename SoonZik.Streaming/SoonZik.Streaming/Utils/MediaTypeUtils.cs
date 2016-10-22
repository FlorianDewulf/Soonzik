using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NAudio.CoreAudioApi.Interfaces;
using NAudio.MediaFoundation;
using NAudio.Utils;

namespace SoonZik.Streaming.Utils
{
    public class MediaTypeUtils
    {
        public MediaTypeUtils()
        {

        }

        public MediaTypeUtils(MediaType mediaType)
        {
            this.MediaType = mediaType;
            this.Name = ShortDescription(mediaType);
            this.Description = DescribeMediaType(mediaType.MediaFoundationObject);
        }

        public MediaType MediaType { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }

        private string ShortDescription(MediaType mediaType)
        {
            Guid subType = mediaType.SubType;
            int sampleRate = mediaType.SampleRate;
            int bytesPerSecond = mediaType.AverageBytesPerSecond;
            int channels = mediaType.ChannelCount;
            int bitsPerSample = mediaType.TryGetUInt32(MediaFoundationAttributes.MF_MT_AUDIO_BITS_PER_SAMPLE);

            //int bitsPerSample;
            //mediaType.GetUINT32(MediaFoundationAttributes.MF_MT_AUDIO_BITS_PER_SAMPLE, out bitsPerSample);
            var shortDescription = new StringBuilder();
            shortDescription.AppendFormat("{0:0.#}kbps, ", (8*bytesPerSecond)/1000M);
            shortDescription.AppendFormat("{0:0.#}kHz, ", sampleRate/1000M);
            if (bitsPerSample != -1)
                shortDescription.AppendFormat("{0} bit, ", bitsPerSample);
            shortDescription.AppendFormat("{0}, ",
                channels == 1 ? "mono" : channels == 2 ? "stereo" : channels.ToString() + " channels");
            if (subType == AudioSubtypes.MFAudioFormat_AAC)
            {
                int payloadType = mediaType.TryGetUInt32(MediaFoundationAttributes.MF_MT_AAC_PAYLOAD_TYPE);
                if (payloadType != -1)
                    shortDescription.AppendFormat("Payload Type: {0}, ", (AacPayloadType) payloadType);
            }
            shortDescription.Length -= 2;
            return shortDescription.ToString();
        }

        private string DescribeMediaType(IMFMediaType mediaType)
        {
            int attributeCount;
            mediaType.GetCount(out attributeCount);
            var sb = new StringBuilder();
            for (int n = 0; n < attributeCount; n++)
            {
                Guid key;
                var val = new PropVariant();
                mediaType.GetItemByIndex(n, out key, ref val);
                string propertyName = FieldDescriptionHelper.Describe(typeof (MediaFoundationAttributes), key);
                sb.AppendFormat("{0}={1}\r\n", propertyName, val.Value);
                val.Clear();
            }
            return sb.ToString();
        }
    }

    enum AacPayloadType
    {
        /// <summary>
        /// The stream contains raw_data_block elements only.
        /// </summary>
        RawData = 0,
        /// <summary>
        /// Audio Data Transport Stream (ADTS). The stream contains an adts_sequence, as defined by MPEG-2.
        /// </summary>
        Adts = 1,
        /// <summary>
        /// Audio Data Interchange Format (ADIF). The stream contains an adif_sequence, as defined by MPEG-2.
        /// </summary>
        Adif = 2,
        /// <summary>
        /// The stream contains an MPEG-4 audio transport stream with a synchronization layer (LOAS) and a multiplex layer (LATM).
        /// </summary>
        LoasLatm = 3
    }
}
